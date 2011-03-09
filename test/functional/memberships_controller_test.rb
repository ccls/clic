require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase

	#	no group_id
	assert_no_route(:get,:index)
	assert_no_route(:get,:new)
	assert_no_route(:post,:create)

	#	no id
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Membership',
		:actions => [:show,:edit,:update,:destroy],	#	only the shallow ones
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_membership
	}
	def factory_attributes(options={})
		Factory.attributes_for(:membership)
#		Factory.attributes_for(:membership,
#			{:group_id => Factory(:group).id}.merge(options))
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })
	assert_no_access_with_login({ 
		:logins => [:editor,:interviewer,:reader,:active_user] })	#	no interviews here
	assert_no_access_without_login


	test "should NOT get new membership without login" do
		group = Factory(:group)
		get :new, :group_id => group.id
		assert_redirected_to_login
	end

	test "should NOT create membership without login" do
		group = Factory(:group)
		assert_difference('Membership.count',0){
			post :create, :group_id => group.id
		}
		assert_redirected_to_login
	end

	test "should NOT get new membership without valid group" do
		login_as active_user
		get :new, :group_id => 0
		assert_redirected_to members_only_path
	end

	test "should NOT create membership without valid group" do
		login_as active_user
		assert_difference('Membership.count',0){
			post :create, :group_id => 0
		}
		assert_redirected_to members_only_path
	end


	test "should get new membership with group and any login" do
		group = Factory(:group)
		login_as active_user
		get :new, :group_id => group.id
		assert_response :success
		assert_template 'new'
	end

	test "should create membership with group and any login" do
		group = Factory(:group)
		login_as active_user
		assert_difference('Membership.count',1){
			post :create, :group_id => group.id
		}
		assert_redirected_to members_only_path
	end


	test "should NOT edit membership with self login" do
		membership = Factory(:membership)
		login_as membership.user
		get :edit, :id => membership.id
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT edit membership with other member login" do
		membership = Factory(:membership)
		other_member = active_user
		Factory(:membership, :user => other_member)
		login_as other_member
		get :edit, :id => membership.id
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT edit membership with other group moderator login" do
#		membership = Factory(:membership)
#		other_membership = Factory(:membership,:group_role => )
#		Factory(:membership, :user => other_member)
#		login_as other_member
#		get :edit, :id => membership.id
#		assert_redirected_to members_only_path
	end

	test "should edit membership with group moderator login" do
	end


	test "should NOT update membership with self login" do
	end

	test "should NOT update membership with other member login" do
	end

	test "should NOT update membership with other group moderator login" do
	end

	test "should update membership with group moderator login" do
	end


	test "should NOT destroy membership with self login" do
	end

	test "should NOT destroy membership with other member login" do
	end

	test "should NOT destroy membership with other group moderator login" do
	end

	test "should destroy membership with group moderator login" do
	end

end
