require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Membership',
		:actions => [:edit,:update,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_membership
	}
	def factory_attributes(options={})
		Factory.attributes_for(:membership,options)
	end

#	setup :create_a_membership
#
#		:logins => [:superuser,:admin,
#		  :editor,:interviewer,:reader,:active_user,
#			:unapproved_group_administrator, :group_administrator,
#			:group_moderator, :group_editor, :group_reader, :group_roleless,
#			:unapproved_nonmember_administrator, :nonmember_administrator,
#			:nonmember_editor, :nonmember_reader, :nonmember_roleless ] })

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })
	assert_no_access_with_login({ 
		:logins => [:editor,:interviewer,:reader,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	%w( superuser admin ).each do |cu|
	
		test "should NOT edit membership with invalid id and #{cu} login" do
			login_as send(cu)
			get :edit, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to memberships_path
		end
	
		test "should NOT update membership with invalid id and #{cu} login" do
			login_as send(cu)
			put :update, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to memberships_path
		end
	
		test "should approve membership with #{cu} login and no params" do
			membership = create_membership(:approved => false)
			login_as send(cu)
			assert !membership.approved?
			put :update, :id => membership.id
			assert  membership.reload.approved?
			assert_redirected_to memberships_path
		end
	
		test "should update membership group role with #{cu} login and new role" do
			create_a_membership
			login_as send(cu)
			assert_equal @membership.group_role, GroupRole['reader']
			put :update, :id => @membership.id, :membership => { 
				:group_role_id => GroupRole['editor'] }
			assert_equal @membership.reload.group_role, GroupRole['editor']
			assert_redirected_to memberships_path
		end
	
		test "should NOT destroy membership with invalid id and #{cu} login" do
			login_as send(cu)
			delete :destroy, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to memberships_path
		end
	
	end

end
