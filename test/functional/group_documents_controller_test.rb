require 'test_helper'

class GroupDocumentsControllerTest < ActionController::TestCase

	#	no group_id
	assert_no_route(:get,:index)
	assert_no_route(:get,:new)
	assert_no_route(:post,:create)

	#	no id
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	def factory_attributes(options={})
		Factory.attributes_for(:group_document)
	end
	def create_group_document(options={})
		Factory(:group_document, options)
	end

#	assert_access_with_login({ 
#		:logins => [:superuser,:admin] })
#	assert_no_access_with_login({ 
#		:logins => [:editor,:interviewer,:reader,:active_user] })	#	no interviews here
#	assert_no_access_without_login

	setup :create_a_membership

	def create_a_membership
		@membership = create_membership
	end

	def create_membership(options={})
		Factory(:membership,{
			:group_role => GroupRole['reader']}.merge(options))
	end

	test "should NOT get new document without login" do
		get :new, :group_id => @membership.group.id
		assert_redirected_to_login
	end

	test "should NOT get new document without valid group" do
		login_as active_user
		get :new, :group_id => 0, :document => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT get new document with group and any login" do
		login_as active_user
		get :new, :group_id => @membership.group.id
		assert_redirected_to root_path
	end

	test "should get new document with group and member login" do
		login_as @membership.user
		get :new, :group_id => @membership.group.id
		assert_response :success
		assert_template 'new'
	end


	test "should NOT create document without login" do
		assert_difference('GroupDocument.count',0){
			post :create, :group_id => @membership.group.id, :document => factory_attributes
		}
		assert_redirected_to_login
	end

	test "should NOT create document without valid group" do
		login_as active_user
		assert_difference('GroupDocument.count',0){
			post :create, :group_id => 0, :document => factory_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT create document with group and any login" do
		login_as active_user
		assert_difference('GroupDocument.count',0){
			post :create, :group_id => @membership.group.id, :document => factory_attributes
		}
		assert_redirected_to root_path
	end

	test "should create document with group and member login" do
		login_as @membership.user
		assert_difference('GroupDocument.count',1){
			post :create, :group_id => @membership.group.id, :document => factory_attributes
		}
		assert assigns(:document)
		assert_equal assigns(:document).user,  @membership.user
		assert_equal assigns(:document).group, @membership.group
		assert_redirected_to group_path(@membership.group)
	end

	test "should NOT create document with admin login when create fails" do
		GroupDocument.any_instance.stubs(:create_or_update).returns(false)
		login_as admin
		assert_difference('GroupDocument.count',0) do
			post :create, :group_id => @membership.group.id, :document => factory_attributes
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create document with admin login and invalid document" do
		GroupDocument.any_instance.stubs(:valid?).returns(false)
		login_as admin
		assert_difference('GroupDocument.count',0) do
			post :create, :group_id => @membership.group.id, :document => factory_attributes
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end


	test "should NOT edit document without login" do
		document = create_group_document(:group => @membership.group)
		get :edit, :group_id => @membership.group.id, :id => document.id
		assert_redirected_to_login
	end

	test "should edit document with self login" do
		document = create_group_document(:group => @membership.group)
			login_as @membership.user
		get :edit, :group_id => @membership.group.id, :id => document.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit document with other member login" do
		document = create_group_document(:group => @membership.group)
#		login_as Factory(:membership,
		login_as create_membership(
			:group => @membership.group).user
		get :edit, :group_id => @membership.group.id, :id => document.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit document with other group moderator login" do
		document = create_group_document(:group => @membership.group)
#		login_as Factory(:membership,
		login_as create_membership(
			:group_role => GroupRole['moderator']).user
		get :edit, :group_id => @membership.group.id, :id => document.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should edit document with group moderator login" do
		document = create_group_document(:group => @membership.group)
#		login_as Factory(:membership,
		login_as create_membership(
			:group => @membership.group,
			:group_role => GroupRole['moderator']).user
		get :edit, :group_id => @membership.group.id, :id => document.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit document with system admin login" do
		document = create_group_document
		login_as admin
		get :edit, :group_id => document.group.id, :id => document.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit document without valid id" do
		document = create_group_document
		login_as admin
		get :edit, :group_id => document.group.id, :id => 0
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should NOT update document without login" do
		document = create_group_document(:group => @membership.group)
		sleep 1
		deny_changes("GroupDocument.find(#{document.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => document.id, :document => factory_attributes
		}
		assert_redirected_to_login
	end

	test "should update document with self login" do
		document = create_group_document(:group => @membership.group)
		sleep 1
		login_as @membership.user
		assert_changes("GroupDocument.find(#{document.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => document.id, :document => factory_attributes
		}
		assert_redirected_to group_path(@membership.group)
	end

	test "should update document with other member login" do
		document = create_group_document(:group => @membership.group)
		sleep 1
#		login_as Factory(:membership, 
		login_as create_membership(
			:group => @membership.group ).user
		assert_changes("GroupDocument.find(#{document.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => document.id, :document => factory_attributes
		}
		assert_redirected_to group_path(@membership.group)
	end

	test "should NOT update document with other group moderator login" do
		document = create_group_document(:group => @membership.group)
#		login_as Factory(:membership,
		login_as create_membership(
			:group_role => GroupRole['moderator']).user
		deny_changes("GroupDocument.find(#{document.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => document.id, :document => factory_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should update document with group moderator login" do
		document = create_group_document(:group => @membership.group)
		sleep 1
#		login_as Factory(:membership,
		login_as create_membership(
			:group => @membership.group,
			:group_role => GroupRole['moderator']).user
		assert_changes("GroupDocument.find(#{document.id}).updated_at") {
			put :update, :group_id => @membership.group.id, :id => document.id, :document => factory_attributes
		}
		assert_redirected_to group_path(document.group)
	end

	test "should update document with system admin login" do
		document = create_group_document
		sleep 1
		login_as admin
		assert_changes("GroupDocument.find(#{document.id}).updated_at") {
			put :update, :group_id => document.group.id, :id => document.id, :document => factory_attributes
		}
		assert_redirected_to group_path(document.group)
	end


	test "should NOT update document with admin login when update fails" do
		document = create_group_document
		GroupDocument.any_instance.stubs(:create_or_update).returns(false)
		login_as admin
		deny_changes("GroupDocument.find(#{document.id}).updated_at") {
			put :update, :group_id => document.group.id, :id => document.id, :document => factory_attributes
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update document with admin login and invalid document" do
		document = create_group_document
		GroupDocument.any_instance.stubs(:valid?).returns(false)
		login_as admin
		deny_changes("GroupDocument.find(#{document.id}).updated_at") {
			put :update, :group_id => document.group.id, :id => document.id, :document => factory_attributes
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update document without valid id" do
		document = create_group_document
		login_as admin
		put :update, :group_id => document.group.id, :id => 0, :document => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end


	test "should NOT destroy document without login" do
		document = create_group_document(:group => @membership.group)
		assert_difference("GroupDocument.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => document.id
		}
		assert_redirected_to_login
	end

	test "should NOT destroy document with self login" do
		document = create_group_document(:group => @membership.group)
		login_as @membership.user
		assert_difference("GroupDocument.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => document.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT destroy document with other member login" do
		document = create_group_document(:group => @membership.group)
#		login_as Factory(:membership,
		login_as create_membership(
			:group => @membership.group).user
		assert_difference("GroupDocument.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => document.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT destroy document with other group moderator login" do
		document = create_group_document(:group => @membership.group)
#		login_as Factory(:membership,
		login_as create_membership(
			:group_role => GroupRole['moderator']).user
		assert_difference("GroupDocument.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => document.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should destroy document with group moderator login" do
		document = create_group_document(:group => @membership.group)
#		login_as Factory(:membership,
		login_as create_membership(
			:group => @membership.group,
			:group_role => GroupRole['moderator']).user
		assert_difference("GroupDocument.count",-1){
			delete :destroy, :group_id => @membership.group.id, :id => document.id
		}
		assert_redirected_to group_path(document.group)
	end

	test "should destroy document with system admin login" do
		document = create_group_document(:group => @membership.group)
		login_as admin
		assert_difference("GroupDocument.count",-1){
			delete :destroy, :group_id => document.group.id, :id => document.id
		}
		assert_redirected_to group_path(document.group)
	end

	test "should NOT destroy document without id" do
		document = create_group_document
		login_as admin
		assert_difference("GroupDocument.count",0){
			delete :destroy, :group_id => document.group.id, :id => 0
		}
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

	test "should NOT get all documents without login" do
		document = create_group_document
		get :index, :group_id => document.group.id
		assert_redirected_to_login
	end

	test "should NOT get all documents with non-member login" do
		login_as active_user
		get :index, :group_id => @membership.group.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get all documents with non-moderator member login" do
		login_as @membership.user
		get :index, :group_id => @membership.group.id
		assert_response :success
		assert_template 'index'
	end

	test "should get all documents with group moderator login" do
		@membership.update_attributes(:group_role => GroupRole['moderator'])
		login_as @membership.user
		get :index, :group_id => @membership.group.id
		assert_response :success
		assert_template 'index'
	end

	test "should get all documents with system admin login" do
		login_as admin
		get :index, :group_id => @membership.group.id
		assert_response :success
		assert_template 'index'
	end


	test "should NOT show document without login" do
		document = create_group_document(:group => @membership.group)
		get :show, :group_id => @membership.group.id, :id => document.id
		assert_redirected_to_login
	end

	test "should NOT show document with non-member login" do
		document = create_group_document(:group => @membership.group)
		login_as active_user
		get :show, :group_id => @membership.group.id, :id => document.id
		assert_redirected_to root_path
	end

	test "should show document with member login" do
		document = create_group_document(:group => @membership.group)
		login_as @membership.user
		get :show, :group_id => @membership.group.id, :id => document.id
		assert_response :success
		assert_template 'show'
	end

	test "should show document with system admin login" do
		document = create_group_document(:group => @membership.group)
		login_as admin
		get :show, :group_id => @membership.group.id, :id => document.id
		assert_response :success
		assert_template 'show'
	end

end
