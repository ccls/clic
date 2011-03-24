require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Group',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_group
	}
	def factory_attributes(options={})
		Factory.attributes_for(:group,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })

	assert_no_access_with_login({ 
		:actions => [:new,:create,:edit,:update,:destroy,:index],
		:logins => [:editor,:interviewer,:reader,:active_user] })

	assert_no_access_with_login({ 
		:actions => [:show],
		:logins => [:editor,:interviewer,:reader,:active_user],
		:redirect => :new_group_membership_path_group
#		:redirect => Proc.new{ new_group_membership_path(assigns(:group)) }
	})

	assert_no_access_without_login

	def new_group_membership_path_group
		new_group_membership_path(assigns(:group))
	end

#	setup :create_a_membership
#
#		:logins => [:editor,:interviewer,:reader,:active_user,
#			:unapproved_group_administrator, :group_administrator,
#			:group_moderator, :group_editor, :group_reader, :group_roleless,
#			:unapproved_nonmember_administrator, :nonmember_administrator,
#			:nonmember_editor, :nonmember_reader, :nonmember_roleless ] })

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :groups_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

%w( superuser admin ).each do |cu|

	test "should NOT create new group with #{cu} login when create fails" do
		Group.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('Group.count',0) do
			post :create, :group => factory_attributes
		end
		assert assigns(:group)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create new group with #{cu} login and invalid group" do
		Group.any_instance.stubs(:valid?).returns(false)
		login_as send(cu)
		assert_difference('Group.count',0) do
			post :create, :group => factory_attributes
		end
		assert assigns(:group)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT update group with #{cu} login when update fails" do
		group = create_group(:updated_at => Chronic.parse('yesterday'))
		Group.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		deny_changes("Group.find(#{group.id}).updated_at") {
			put :update, :id => group.id,
				:group => factory_attributes
		}
		assert assigns(:group)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update group with #{cu} login and invalid group" do
		group = create_group(:updated_at => Chronic.parse('yesterday'))
		Group.any_instance.stubs(:valid?).returns(false)
		login_as send(cu)
		deny_changes("Group.find(#{group.id}).updated_at") {
			put :update, :id => group.id,
				:group => factory_attributes
		}
		assert assigns(:group)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

end

end
