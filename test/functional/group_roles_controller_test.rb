require 'test_helper'

class GroupRolesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'GroupRole',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_group_role
	}
	def factory_attributes(options={})
		Factory.attributes_for(:group_role,options)
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login({ 
		:logins => site_administrators })

	assert_no_access_with_login({ 
		:logins => ( ALL_TEST_ROLES - site_administrators ) })

	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :group_roles_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|
	
		test "should NOT create new group_role with #{cu} login when create fails" do
			GroupRole.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('GroupRole.count',0) do
				post :create, :group_role => factory_attributes
			end
			assert assigns(:group_role)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end
	
		test "should NOT create new group_role with #{cu} login and invalid group_role" do
			GroupRole.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			assert_difference('GroupRole.count',0) do
				post :create, :group_role => factory_attributes
			end
			assert assigns(:group_role)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end
	
		test "should NOT update group_role with #{cu} login when update fails" do
			group_role = create_group_role(:updated_at => Chronic.parse('yesterday'))
			GroupRole.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("GroupRole.find(#{group_role.id}).updated_at") {
				put :update, :id => group_role.id,
					:group_role => factory_attributes
			}
			assert assigns(:group_role)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
		test "should NOT update group_role with #{cu} login and invalid group_role" do
			group_role = create_group_role(:updated_at => Chronic.parse('yesterday'))
			GroupRole.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("GroupRole.find(#{group_role.id}).updated_at") {
				put :update, :id => group_role.id,
					:group_role => factory_attributes
			}
			assert assigns(:group_role)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
	end

end
