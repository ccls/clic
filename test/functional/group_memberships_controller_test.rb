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

	def factory_attributes(options={})
		Factory.attributes_for(:membership)
	end

	setup :create_a_membership

	roles_that_can_create = %w( super_user admin editor reader active_user 
		group_roleless
		nonmember_administrator nonmember_moderator 
		nonmember_editor nonmember_reader nonmember_roleless )

	roles_that_cannot_create = %w( group_administrator group_moderator 
		group_editor group_reader )

	roles_that_can_edit = %w( super_user admin group_administrator group_moderator )

	roles_that_cannot_edit = %w( editor reader active_user 
		group_editor group_reader group_roleless
		unapproved_group_administrator unapproved_nonmember_administrator
		nonmember_administrator nonmember_moderator 
		nonmember_editor nonmember_reader nonmember_roleless )

	roles_that_can_view = %w( super_user admin group_administrator group_moderator
		group_editor group_reader )

	roles_that_cannot_view = %w( editor reader active_user group_roleless
		unapproved_group_administrator unapproved_nonmember_administrator
		nonmember_administrator nonmember_moderator
		nonmember_editor nonmember_reader nonmember_roleless )


	roles_that_can_edit.each do |cu|

		test "should edit membership with #{cu} login" do
			login_as send(cu)
			get :edit, :group_id => @membership.group.id, :id => @membership.id
			assert_response :success
			assert_template 'edit'
		end

		test "should NOT edit membership without valid id with #{cu} login" do
			login_as send(cu)
			get :edit, :group_id => @membership.group.id, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should update membership with #{cu} login" do
			login_as send(cu)
			assert_changes("Membership.find(#{@membership.id}).group_role_id") {
				put :update, 
					:group_id => @membership.group.id, 
					:id => @membership.id, 
					:membership => { :group_role_id => GroupRole[:editor].id }
			}
			assert_redirected_to group_path(@membership.group)
		end
	
		test "should NOT update membership when update fails " <<
				"with #{cu} login" do
			login_as send(cu)
			Membership.any_instance.stubs(:create_or_update).returns(false)
			deny_changes("Membership.find(#{@membership.id}).group_role_id") {
				put :update, 
					:group_id => @membership.group.id, 
					:id => @membership.id, 
					:membership => { :group_role_id => GroupRole[:editor].id }
			}
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
		test "should NOT update membership with invalid membership " <<
				"with #{cu} login" do
			login_as send(cu)
			Membership.any_instance.stubs(:valid?).returns(false)
			deny_changes("Membership.find(#{@membership.id}).group_role_id") {
				put :update, 
					:group_id => @membership.group.id, 
					:id => @membership.id, 
					:membership => { :group_role_id => GroupRole[:editor].id }
			}
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
		test "should NOT update membership without valid id with #{cu} login" do
			login_as send(cu)
			put :update, 
				:group_id => @membership.group.id, 
				:id => 0, 
				:membership => { :group_role_id => GroupRole[:editor].id }
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end
	
		test "should NOT update membership without valid group_role_id with #{cu} login" do
			login_as send(cu)
			put :update, 
				:group_id => @membership.group.id, 
				:id => @membership.id, 
				:membership => { :group_role_id => 0 }
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should destroy membership with #{cu} login" do
			login_as send(cu)
			assert_difference("Membership.count",-1){
				delete :destroy, :group_id => @membership.group.id, :id => @membership.id
			}
			assert_redirected_to members_only_path
		end

		test "should NOT destroy membership without id with #{cu} login" do
			login_as send(cu)
			assert_difference("Membership.count",0){
				delete :destroy, :group_id => @membership.group.id, :id => 0
			}
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

	end

	roles_that_cannot_edit.each do |cu|

		test "should NOT edit membership with #{cu} login" do
			login_as send(cu)
			get :edit, :group_id => @membership.group.id, :id => @membership.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path				#	members_only_path
		end

		test "should NOT update membership with #{cu} login" do
			login_as send(cu)
			deny_changes("Membership.find(#{@membership.id}).group_role_id") {
				put :update, 
					:group_id => @membership.group.id, 
					:id => @membership.id, 
					:membership => { :group_role_id => GroupRole[:editor].id }
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path	#	members_only_path
		end

		test "should NOT destroy membership with #{cu} login" do
			login_as send(cu)
			assert_difference("Membership.count",0){
				delete :destroy, :group_id => @membership.group.id, :id => @membership.id
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path	#	members_only_path
		end

	end


	#
	#	Only non-members should be allowed to create.
	#
	roles_that_can_create.each do |cu|

		test "should NOT get new membership without valid group and #{cu} login" do
			login_as send(cu)
			get :new, :group_id => 0
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should get new membership with group and #{cu} login" do
			login_as send(cu)
			get :new, :group_id => @membership.group.id
			assert_response :success
			assert_template 'new'
		end
	
		test "should NOT create membership without valid group and #{cu} login" do
			login_as send(cu)
			assert_difference('Membership.count',0){
				post :create, :group_id => 0
			}
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end
	
		test "should create membership with group and #{cu} login" do
			login_as send(cu)
			assert_difference('Membership.count',1){
				post :create, :group_id => @membership.group.id
			}
			assert !assigns(:membership).approved?
			assert_redirected_to members_only_path
		end
	
		test "should create membership with group, group role and #{cu} login" do
			login_as send(cu)
			assert_difference('Membership.count',1){
				post :create, :group_id => @membership.group.id,
					:membership => { :group_role_id => GroupRole['editor'].id }
			}
			assert_equal assigns(:membership).group_role, GroupRole['editor']
			assert !assigns(:membership).approved?
			assert_redirected_to members_only_path
		end
	
		test "should NOT create membership with #{cu} login when create fails" do
			login_as send(cu)
			Membership.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Membership.count',0) do
				post :create, :group_id => @membership.group.id
			end
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end
	
		test "should NOT create membership with #{cu} login and invalid membership" do
			login_as send(cu)
			Membership.any_instance.stubs(:valid?).returns(false)
			assert_difference('Membership.count',0) do
				post :create, :group_id => @membership.group.id
			end
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

	end

	#
	#	Members should NOT be allowed to create a membership.
	#
	roles_that_cannot_create.each do |cu|

		test "should NOT get new membership with #{cu} login" do
			login_as send(cu)
			get :new, :group_id => @membership.group.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path			#	members_only_path
		end

		test "should NOT create membership with #{cu} login" do
			login_as send(cu)
			assert_difference('Membership.count',0){
				post :create, :group_id => @membership.group.id
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path			#	members_only_path
		end

	end

	######################################################################
	#
	#	Members and site admins should be able to view
	#
	roles_that_can_view.each do |cu|

		test "should show membership with #{cu} login" do
			login_as send(cu)
			get :show, :group_id => @membership.group.id, :id => @membership.id
			assert_response :success
			assert_template 'show'
		end

		test "should get all memberships with #{cu} login" do
			login_as send(cu)
			get :index, :group_id => @membership.group.id
			assert_response :success
			assert_template 'index'
		end

	end

	#
	#	Non-members should not be able to view
	#
	roles_that_cannot_view.each do |cu|

		test "should NOT show membership with #{cu} login" do
			login_as send(cu)
			get :show, :group_id => @membership.group.id, :id => @membership.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT get all memberships with #{cu} login" do
			login_as send(cu)
			get :index, :group_id => @membership.group.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end


	######################################################################
	#
	#		Self login (can show, but nothing else)
	#

	test "should show membership with self login" do
		pending
	end

	test "should NOT get new membership with self login" do
		#	already have one
		pending
	end

	test "should NOT create new membership with self login" do
		#	already have one
		pending
	end

	test "should NOT get all memberships with self login" do
		#	already have one
		pending
	end

	test "should NOT edit membership with self login" do
		login_as @membership.user
		get :edit, :group_id => @membership.group.id, :id => @membership.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT update membership with self login" do
		login_as @membership.user
		deny_changes("Membership.find(#{@membership.id}).group_role_id") {
			put :update, 
				:group_id => @membership.group.id, 
				:id => @membership.id, 
				:membership => { :group_role_id => GroupRole[:editor].id }
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	test "should NOT destroy membership with self login" do
		login_as @membership.user
		assert_difference("Membership.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => @membership.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#	members_only_path
	end

	######################################################################
	#
	#		No login
	#
	test "should NOT get new membership without login" do
		get :new, :group_id => @membership.group.id
		assert_redirected_to_login
	end

	test "should NOT create membership without login" do
		assert_difference('Membership.count',0){
			post :create, :group_id => @membership.group.id
		}
		assert_redirected_to_login
	end

	test "should NOT edit membership without login" do
		get :edit, :group_id => @membership.group.id, :id => @membership.id
		assert_redirected_to_login
	end

	test "should NOT update membership without login" do
		deny_changes("Membership.find(#{@membership.id}).group_role_id") {
			put :update, 
				:group_id => @membership.group.id, 
				:id => @membership.id, 
				:membership => { :group_role_id => GroupRole[:editor].id }
		}
		assert_redirected_to_login
	end

	test "should NOT destroy membership without login" do
		assert_difference("Membership.count",0){
			delete :destroy, :group_id => @membership.group.id, :id => @membership.id
		}
		assert_redirected_to_login
	end

	test "should NOT get all memberships without login" do
		get :index, :group_id => @membership.group.id
		assert_redirected_to_login
	end

	test "should NOT show membership without login" do
		get :show, :group_id => @membership.group.id, :id => @membership.id
		assert_redirected_to_login
	end


end
