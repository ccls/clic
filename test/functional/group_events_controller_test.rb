require 'test_helper'

class GroupEventsControllerTest < ActionController::TestCase

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
#		:model => 'Event',
#		:actions => [:show,:edit,:update,:destroy],	#	only the shallow ones
##		:actions => [:show,:edit,:destroy],	#	only the shallow ones (without update)
#		:attributes_for_create => :factory_attributes,
#		:method_for_create => :create_group_event
##		:method_for_create => :create_announcement
#	}
	def factory_attributes(options={})
		Factory.attributes_for(:group_event)
#		Factory.attributes_for(:membership,
#			{:group_id => Factory(:group).id}.merge(options))
	end
	def create_group_event(options={})
		Factory(:group_event, options)
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

	test "should NOT get new event without login" do
		group = Factory(:group)
		get :new, :group_id => group.id
		assert_redirected_to_login
	end

	test "should NOT get new event without valid group" do
		login_as active_user
		get :new, :group_id => 0, :event => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT get new event with group and any login" do
		group = Factory(:group)
		login_as active_user
		get :new, :group_id => group.id
		assert_redirected_to root_path
	end

	test "should get new event with group and member login" do
		login_as @membership.user
		get :new, :group_id => @membership.group.id
		assert_response :success
		assert_template 'new'
	end



	test "should NOT create event without login" do
		assert_difference('Event.count',0){
			post :create, :group_id => @membership.group.id, :event => factory_attributes
		}
		assert_redirected_to_login
	end

	test "should NOT create event without valid group" do
		login_as active_user
		assert_difference('Event.count',0){
			post :create, :group_id => 0, :event => factory_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT create event with group and any login" do
		login_as active_user
		assert_difference('Event.count',0){
			post :create, :group_id => @membership.group.id, :event => factory_attributes
		}
		assert_redirected_to root_path
	end

	test "should create event with group and member login" do
		login_as @membership.user
		assert_difference('Event.count',1){
			post :create, :group_id => @membership.group.id, :event => factory_attributes
		}
		assert assigns(:event)
		assert_equal assigns(:event).user,  @membership.user
		assert_equal assigns(:event).group, @membership.group
		assert_redirected_to group_path(@membership.group)
	end

	test "should NOT create event with admin login when create fails" do
		Event.any_instance.stubs(:create_or_update).returns(false)
		login_as admin
		assert_difference('Event.count',0) do
			post :create, :group_id => @membership.group.id, :event => factory_attributes
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create event with admin login and invalid event" do
		Event.any_instance.stubs(:valid?).returns(false)
		login_as admin
		assert_difference('Event.count',0) do
			post :create, :group_id => @membership.group.id, :event => factory_attributes
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end



	test "should NOT edit event without login" do

	end

	test "should edit event with self login" do
		event = create_group_event(:group => @membership.group)
		login_as @membership.user
		get :edit, :group_id => @membership.group.id, :id => event.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit event with other member login" do
		event = create_group_event(:group => @membership.group)
		Factory(:event, :user => @membership.user)
		login_as Factory(:membership,:group => @membership.group).user
		get :edit, :group_id => @membership.group.id, :id => event.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit event with other group moderator login" do
		event = create_group_event(:group => @membership.group)
		login_as Factory(:membership,
			:group_role => GroupRole['moderator']).user
		get :edit, :group_id => @membership.group.id, :id => event.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should edit event with group moderator login" do
		event = create_group_event(:group => @membership.group)
		login_as Factory(:membership,
			:group => @membership.group,
			:group_role => GroupRole['moderator']).user
		get :edit, :group_id => @membership.group.id, :id => event.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit event with system admin login" do
		event = create_group_event
		login_as admin
		get :edit, :group_id => @membership.group.id, :id => event.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit event without valid id" do
		login_as admin
		get :edit, :group_id => @membership.group.id, :id => 0
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT edit event without group" do
		event = Factory(:event)
		login_as admin
		get :edit, :group_id => @membership.group.id, :id => event.id
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should NOT update event without login" do

	end

	test "should update event with self login" do
		event = create_group_event(:group => @membership.group)
		sleep 1
		login_as @membership.user
		assert_changes("Event.find(#{event.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => event.id, :event => factory_attributes
		}
		assert_redirected_to group_path(@membership.group)
	end

	test "should update event with other member login" do
		event = create_group_event(:group => @membership.group)
		sleep 1
		login_as Factory(:membership, :group => @membership.group ).user
		assert_changes("Event.find(#{event.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => event.id, :event => factory_attributes
		}
		assert_redirected_to group_path(@membership.group)
	end

	test "should NOT update event with other group moderator login" do
		event = create_group_event(:group => @membership.group)
		login_as Factory(:membership,
			:group_role => GroupRole['moderator']).user
		deny_changes("Event.find(#{event.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => event.id, :event => factory_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should update event with group moderator login" do
		event = create_group_event(:group => @membership.group)
		sleep 1
		login_as Factory(:membership,
			:group => @membership.group,
			:group_role => GroupRole['moderator']).user
		assert_changes("Event.find(#{event.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => event.id, :event => factory_attributes
		}
		assert_redirected_to group_path(event.group)
	end

	test "should update event with system admin login" do
		event = create_group_event
		sleep 1
		login_as admin
		assert_changes("Event.find(#{event.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => event.id, :event => factory_attributes
		}
		assert_redirected_to group_path(event.group)
	end

	test "should NOT update event without group" do
		event = Factory(:event)
		login_as admin
		deny_changes("Event.find(#{event.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => event.id, :event => factory_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should NOT update event with admin login when update fails" do
		event = create_group_event
		Event.any_instance.stubs(:create_or_update).returns(false)
		login_as admin
		deny_changes("Event.find(#{event.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => event.id, :event => factory_attributes
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update event with admin login and invalid event" do
		event = create_group_event
		Event.any_instance.stubs(:valid?).returns(false)
		login_as admin
		deny_changes("Event.find(#{event.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => event.id, :event => factory_attributes
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update event without valid id" do
		login_as admin
		put :update, :group_id => @membership.group.id, :id => 0, :event => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should NOT destroy event without login" do

	end

	test "should NOT destroy event with self login" do
		event = create_group_event(:group => @membership.group)
		login_as @membership.user
		assert_difference("Event.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => event.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT destroy event with other member login" do
		event = create_group_event(:group => @membership.group)
		login_as Factory(:membership,:group => @membership.group).user
		assert_difference("Event.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => event.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT destroy event with other group moderator login" do
		event = create_group_event(:group => @membership.group)
		login_as Factory(:membership,
			:group_role => GroupRole['moderator']).user
		assert_difference("Event.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => event.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should destroy event with group moderator login" do
		event = create_group_event(:group => @membership.group)
		login_as Factory(:membership,
			:group => @membership.group,
			:group_role => GroupRole['moderator']).user
		assert_difference("Event.count",-1){
			delete :destroy, :group_id => @membership.group.id, :id => event.id
		}
		assert_redirected_to group_path(event.group)
	end

	test "should destroy event with system admin login" do
		event = create_group_event
		login_as admin
		assert_difference("Event.count",-1){
			delete :destroy, :group_id => @membership.group.id, :id => event.id
		}
		assert_redirected_to group_path(event.group)
	end

	test "should NOT destroy event without group" do
		event = Factory(:event)
		login_as admin
		assert_difference("Event.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => event.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT destroy event without id" do
		login_as admin
		assert_difference("Event.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => 0
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT get all events without login" do
		event = create_group_event
		get :index, :group_id => event.group.id
		assert_redirected_to_login
	end

	test "should NOT get all events with non-member login" do
		login_as active_user
		get :index, :group_id => @membership.group.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get all events with non-moderator member login" do
		login_as @membership.user
		get :index, :group_id => @membership.group.id
		assert_response :success
		assert_template 'index'
	end

	test "should get all events with group moderator login" do
		@membership.update_attributes(:group_role => GroupRole['moderator'])
		login_as @membership.user
		get :index, :group_id => @membership.group.id
		assert_response :success
		assert_template 'index'
	end

	test "should get all events with system admin login" do
		login_as admin
		get :index, :group_id => @membership.group.id
		assert_response :success
		assert_template 'index'
	end


	test "should NOT show event without login" do

	end

	test "should NOT show event with non-member login" do

	end

	test "should show event with member login" do

	end

	test "should show even with system admin login" do

	end

end
