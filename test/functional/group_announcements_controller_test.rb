require 'test_helper'

class GroupAnnouncementsControllerTest < ActionController::TestCase

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
		:model => 'Announcement',
		:actions => [:show,:edit,:update,:destroy],	#	only the shallow ones
#		:actions => [:show,:edit,:destroy],	#	only the shallow ones (without update)
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_group_announcement
#		:method_for_create => :create_announcement
	}
	def factory_attributes(options={})
		Factory.attributes_for(:group_announcement)
#		Factory.attributes_for(:membership,
#			{:group_id => Factory(:group).id}.merge(options))
	end
	def create_group_announcement(options={})
		Factory(:group_announcement, options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })
	assert_no_access_with_login({ 
		:logins => [:editor,:interviewer,:reader,:active_user] })	#	no interviews here
	assert_no_access_without_login


	test "should NOT get new announcement without login" do
		group = Factory(:group)
		get :new, :group_id => group.id
		assert_redirected_to_login
	end

	test "should NOT create announcement without login" do
		group = Factory(:group)
		assert_difference('Announcement.count',0){
			post :create, :group_id => group.id, :announcement => factory_attributes
		}
		assert_redirected_to_login
	end

	test "should NOT get new announcement without valid group" do
		login_as active_user
		get :new, :group_id => 0, :announcement => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT create announcement without valid group" do
		login_as active_user
		assert_difference('Announcement.count',0){
			post :create, :group_id => 0, :announcement => factory_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should NOT get new announcement with group and any login" do
		group = Factory(:group)
		login_as active_user
		get :new, :group_id => group.id
		assert_redirected_to root_path
	end

	test "should NOT create announcement with group and any login" do
		group = Factory(:group)
		login_as active_user
		assert_difference('Announcement.count',0){
			post :create, :group_id => group.id, :announcement => factory_attributes
		}
		assert_redirected_to root_path
	end

	test "should NOT create announcement with admin login when create fails" do
		Announcement.any_instance.stubs(:create_or_update).returns(false)
		group = Factory(:group)
		login_as admin
		assert_difference('Announcement.count',0) do
			post :create, :group_id => group.id, :announcement => factory_attributes
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create announcement with admin login and invalid announcement" do
		Announcement.any_instance.stubs(:valid?).returns(false)
		group = Factory(:group)
		login_as admin
		assert_difference('Announcement.count',0) do
			post :create, :group_id => group.id, :announcement => factory_attributes
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end



	test "should edit announcement with self login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		login_as membership.user
		get :edit, :id => announcement.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit announcement with other member login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		Factory(:announcement, :user => membership.user)
		login_as Factory(:membership,:group => membership.group).user
		get :edit, :id => announcement.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit announcement with other group moderator login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		login_as Factory(:membership,
			:group_role => GroupRole['moderator']).user
		get :edit, :id => announcement.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should edit announcement with group moderator login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		login_as Factory(:membership,
			:group => membership.group,
			:group_role => GroupRole['moderator']).user
		get :edit, :id => announcement.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit announcement with system admin login" do
		announcement = create_group_announcement
		login_as admin
		get :edit, :id => announcement.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit announcement without valid id" do
		login_as admin
		get :edit, :id => 0
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT edit announcement without group" do
		announcement = Factory(:announcement)
		login_as admin
		get :edit, :id => announcement.id
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should update announcement with self login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		sleep 1
		login_as membership.user
		assert_changes("Announcement.find(#{announcement.id}).updated_at") {
			put :update, :id => announcement.id, :announcement => factory_attributes
		}
		assert_redirected_to group_path(membership.group)
	end

	test "should update announcement with other member login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		sleep 1
		login_as Factory(:membership, :group => membership.group ).user
		assert_changes("Announcement.find(#{announcement.id}).updated_at") {
			put :update, :id => announcement.id, :announcement => factory_attributes
		}
		assert_redirected_to group_path(membership.group)
	end

	test "should NOT update announcement with other group moderator login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		login_as Factory(:membership,
			:group_role => GroupRole['moderator']).user
		deny_changes("Announcement.find(#{announcement.id}).updated_at") {
			put :update, :id => announcement.id, :announcement => factory_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should update announcement with group moderator login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		sleep 1
		login_as Factory(:membership,
			:group => membership.group,
			:group_role => GroupRole['moderator']).user
		assert_changes("Announcement.find(#{announcement.id}).updated_at") {
			put :update, :id => announcement.id, :announcement => factory_attributes
		}
		assert_redirected_to group_path(announcement.group)
	end

	test "should update announcement with system admin login" do
		announcement = create_group_announcement
		sleep 1
		login_as admin
		assert_changes("Announcement.find(#{announcement.id}).updated_at") {
			put :update, :id => announcement.id, :announcement => factory_attributes
		}
		assert_redirected_to group_path(announcement.group)
	end

	test "should NOT update announcement without group" do
		announcement = Factory(:announcement)
		login_as admin
		deny_changes("Announcement.find(#{announcement.id}).updated_at") {
			put :update, :id => announcement.id, :announcement => factory_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should NOT update announcement with admin login when update fails" do
		announcement = create_group_announcement
		Announcement.any_instance.stubs(:create_or_update).returns(false)
		login_as admin
		deny_changes("Announcement.find(#{announcement.id}).updated_at") {
			put :update, :id => announcement.id, :announcement => factory_attributes
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update announcement with admin login and invalid announcement" do
		announcement = create_group_announcement
		Announcement.any_instance.stubs(:valid?).returns(false)
		login_as admin
		deny_changes("Announcement.find(#{announcement.id}).updated_at") {
			put :update, :id => announcement.id, :announcement => factory_attributes
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update announcement without valid id" do
		login_as admin
		put :update, :id => 0, :announcement => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should NOT destroy announcement with self login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		login_as membership.user
		assert_difference("Announcement.count",0){
			delete :destroy, :id => announcement.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT destroy announcement with other member login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		login_as Factory(:membership).user
		assert_difference("Announcement.count",0){
			delete :destroy, :id => announcement.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT destroy announcement with other group moderator login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		login_as Factory(:membership,
			:group_role => GroupRole['moderator']).user
		assert_difference("Announcement.count",0){
			delete :destroy, :id => announcement.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should destroy announcement with group moderator login" do
		membership = Factory(:membership)
		announcement = create_group_announcement(:group => membership.group)
		login_as Factory(:membership,
			:group => membership.group,
			:group_role => GroupRole['moderator']).user
		assert_difference("Announcement.count",-1){
			delete :destroy, :id => announcement.id
		}
		assert_redirected_to group_path(announcement.group)
	end

	test "should destroy announcement with system admin login" do
		announcement = create_group_announcement
		login_as admin
		assert_difference("Announcement.count",-1){
			delete :destroy, :id => announcement.id
		}
		assert_redirected_to group_path(announcement.group)
	end

	test "should NOT destroy announcement without group" do
		announcement = Factory(:announcement)
		login_as admin
		assert_difference("Announcement.count",0){
			delete :destroy, :id => announcement.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT destroy announcement without id" do
		login_as admin
		assert_difference("Announcement.count",0){
			delete :destroy, :id => 0
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT get all announcements without login" do
		announcement = create_group_announcement
		get :index, :group_id => announcement.group.id
		assert_redirected_to_login
	end

	test "should NOT get all announcements with non-member login" do
		membership = Factory(:membership)
		login_as active_user
		get :index, :group_id => membership.group.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get all announcements with non-moderator member login" do
		membership = Factory(:membership)
		login_as membership.user
		get :index, :group_id => membership.group.id
		assert_response :success
		assert_template 'index'
	end

	test "should get all announcements with group moderator login" do
		membership = Factory(:membership,:group_role => GroupRole['moderator'])
		login_as membership.user
		get :index, :group_id => membership.group.id
		assert_response :success
		assert_template 'index'
	end

	test "should get all announcements with system admin login" do
		group = Factory(:group)
		login_as admin
		get :index, :group_id => group.id
		assert_response :success
		assert_template 'index'
	end

end
