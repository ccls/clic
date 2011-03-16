require 'test_helper'

class GroupMembershipsControllerTest < ActionController::TestCase

	#	no group_id
	assert_no_route(:get,:index)
	assert_no_route(:get,:new)
	assert_no_route(:post,:create)

	#	no id
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

#	ASSERT_ACCESS_OPTIONS = {
#		:model => 'Membership',
##		:actions => [:show,:edit,:update,:destroy],	#	only the shallow ones
#		:actions => [:show,:edit,:destroy],	#	only the shallow ones (without update)
#		:attributes_for_create => :factory_attributes,
#		:method_for_create => :create_membership
#	}
	def factory_attributes(options={})
		Factory.attributes_for(:membership)
#		Factory.attributes_for(:membership,
#			{:group_id => Factory(:group).id}.merge(options))
	end
#
#	assert_access_with_login({ 
#		:logins => [:superuser,:admin] })
#	assert_no_access_with_login({ 
#		:logins => [:editor,:interviewer,:reader,:active_user] })	#	no interviews here
#	assert_no_access_without_login

	setup :create_a_membership

	def create_a_membership
		@membership = Factory(:membership)
	end


	test "should NOT get new membership without login" do
		get :new, :group_id => @membership.group.id
		assert_redirected_to_login
	end

	test "should NOT get new membership without valid group" do
		login_as active_user
		get :new, :group_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should get new membership with group and any login" do
		login_as active_user
		get :new, :group_id => @membership.group.id
		assert_response :success
		assert_template 'new'
	end


	test "should NOT create membership without login" do
		assert_difference('Membership.count',0){
			post :create, :group_id => @membership.group.id
		}
		assert_redirected_to_login
	end

	test "should NOT create membership without valid group" do
		login_as active_user
		assert_difference('Membership.count',0){
			post :create, :group_id => 0
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should create membership with group and any login" do
		login_as active_user
		assert_difference('Membership.count',1){
			post :create, :group_id => @membership.group.id
		}
		assert_redirected_to members_only_path
	end

	test "should NOT create membership with admin login when create fails" do
		Membership.any_instance.stubs(:create_or_update).returns(false)
		login_as admin
		assert_difference('Membership.count',0) do
			post :create, :group_id => @membership.group.id
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create membership with admin login and invalid membership" do
		Membership.any_instance.stubs(:valid?).returns(false)
		login_as admin
		assert_difference('Membership.count',0) do
			post :create, :group_id => @membership.group.id
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end


	test "should NOT edit membership without login" do
		get :edit, :group_id => @membership.group.id, :id => @membership.id
		assert_redirected_to_login
	end

	test "should NOT edit membership with self login" do
		login_as @membership.user
		get :edit, :group_id => @membership.group.id, :id => @membership.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT edit membership with other member login" do
		login_as Factory(:membership, :group => @membership.group).user
		get :edit, :group_id => @membership.group.id, :id => @membership.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT edit membership with other group moderator login" do
		other_membership = Factory(:membership,
			:group_role => GroupRole['moderator'])
		login_as other_membership.user
		get :edit, :group_id => @membership.group.id, :id => @membership.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should edit membership with group moderator login" do
		other_membership = Factory(:membership,
			:group => @membership.group,
			:group_role => GroupRole['moderator'])
		login_as other_membership.user
		get :edit, :group_id => @membership.group.id, :id => @membership.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit membership with system admin login" do
		login_as admin
		get :edit, :group_id => @membership.group.id, :id => @membership.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit membership without valid id" do
		login_as admin
		get :edit, :group_id => @membership.group.id, :id => 0
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should NOT update membership without login" do
		deny_changes("Membership.find(#{@membership.id}).group_role_id") {
			put :update, :group_id => @membership.group.id, :id => @membership.id, :membership => { :group_role_id => 0 }
		}
		assert_redirected_to_login
	end

	test "should NOT update membership with self login" do
		login_as @membership.user
		deny_changes("Membership.find(#{@membership.id}).group_role_id") {
			put :update, :group_id => @membership.group.id, :id => @membership.id, :membership => { :group_role_id => 0 }
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT update membership with other member login" do
		login_as Factory(:membership, :group => @membership.group ).user
		deny_changes("Membership.find(#{@membership.id}).group_role_id") {
			put :update, :group_id => @membership.group.id, :id => @membership.id, :membership => { :group_role_id => 0 }
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT update membership with other group moderator login" do
		login_as Factory(:membership,
			:group_role => GroupRole['moderator']).user
		deny_changes("Membership.find(#{@membership.id}).group_role_id") {
			put :update, :group_id => @membership.group.id, :id => @membership.id, :membership => { :group_role_id => 0 }
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should update membership with group moderator login" do
		login_as Factory(:membership,
			:group => @membership.group,
			:group_role => GroupRole['moderator']).user
		assert_changes("Membership.find(#{@membership.id}).group_role_id") {
			put :update, :group_id => @membership.group.id, :id => @membership.id, :membership => { :group_role_id => 0 }
		}
		assert_redirected_to group_path(@membership.group)
	end

	test "should update membership with system admin login" do
		login_as admin
		assert_changes("Membership.find(#{@membership.id}).group_role_id") {
			put :update, :group_id => @membership.group.id, :id => @membership.id, :membership => { :group_role_id => 0 }
		}
		assert_redirected_to group_path(@membership.group)
	end


	test "should NOT update membership with admin login when update fails" do
		Membership.any_instance.stubs(:create_or_update).returns(false)
		login_as admin
		deny_changes("Membership.find(#{@membership.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => @membership.id, :membership => { :group_role_id => 0 }
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update membership with admin login and invalid membership" do
		Membership.any_instance.stubs(:valid?).returns(false)
		login_as admin
		deny_changes("Membership.find(#{@membership.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => @membership.id, :membership => { :group_role_id => 0 }
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update membership without valid id" do
		login_as admin
		put :update, :group_id => @membership.group.id, :id => 0, :membership => { :group_role_id => 0 }
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT destroy membership without login" do
		assert_difference("Membership.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => @membership.id
		}
		assert_redirected_to_login
	end

	test "should NOT destroy membership with self login" do
		login_as @membership.user
		assert_difference("Membership.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => @membership.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT destroy membership with other member login" do
		login_as Factory(:membership, :group => @membership.group).user
		assert_difference("Membership.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => @membership.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT destroy membership with other group moderator login" do
		login_as Factory(:membership,
			:group_role => GroupRole['moderator']).user
		assert_difference("Membership.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => @membership.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should destroy membership with group moderator login" do
		login_as Factory(:membership,
			:group => @membership.group,
			:group_role => GroupRole['moderator']).user
		assert_difference("Membership.count",-1){
			delete :destroy, :group_id => @membership.group.id, :id => @membership.id
		}
		assert_redirected_to members_only_path
	end

	test "should destroy membership with system admin login" do
		login_as admin
		assert_difference("Membership.count",-1){
			delete :destroy, :group_id => @membership.group.id, :id => @membership.id
		}
		assert_redirected_to members_only_path
	end

	test "should NOT destroy membership without id" do
		login_as admin
		assert_difference("Membership.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => 0
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT get all memberships without login" do
		get :index, :group_id => @membership.group.id
		assert_redirected_to_login
	end

	test "should NOT get all memberships with non-member login" do
		login_as active_user
		get :index, :group_id => @membership.group.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get all memberships with non-moderator member login" do
		login_as @membership.user
		get :index, :group_id => @membership.group.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get all memberships with group moderator login" do
		@membership.update_attributes(:group_role => GroupRole['moderator'])
		login_as @membership.user
		get :index, :group_id => @membership.group.id
		assert_response :success
		assert_template 'index'
	end

	test "should get all memberships with system admin login" do
		login_as admin
		get :index, :group_id => @membership.group.id
		assert_response :success
		assert_template 'index'
	end

	test "should NOT show membership without login" do
		get :show, :group_id => @membership.group.id, :id => @membership.id
		assert_redirected_to_login
	end

	test "should NOT show membership with non-member login" do
		login_as active_user
		get :show, :group_id => @membership.group.id, :id => @membership.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should show membership with member login" do
		login_as @membership.user
		get :show, :group_id => @membership.group.id, :id => @membership.id
		assert_response :success
		assert_template 'show'
	end

	test "should show membership with system admin login" do
		login_as admin
		get :show, :group_id => @membership.group.id, :id => @membership.id
		assert_response :success
		assert_template 'show'
	end

end
