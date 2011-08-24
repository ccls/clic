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

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login({    :logins => site_administrators })
	assert_no_access_with_login({ :logins => non_site_administrators,
		:no_redirect_check => true })
#	response to be a redirect to <https://test.host:80/> 
#		but was a redirect to <https://test.host:80/groups/1018266145/memberships/new>.
#		:redirect => new_group_membership_path(@membership.group) })
	assert_no_access_without_login
	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :groups_path,
		:edit    => { :id => 0 },
		:update  => { :id => 0 },
		:show    => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should get new group with #{cu} login" do
			login_as send(cu)
			get :new
			assert assigns(:group)
			assert_response :success
			assert_template 'new'
		end
	
		test "should create group with #{cu} login" do
			login_as send(cu)
			assert_difference('Group.count',1) do
				post :create, :group => factory_attributes
			end
			assert assigns(:group)
			assert_redirected_to group_path(assigns(:group))
			assert_not_nil flash[:notice]
		end
	
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

		test "should get index with #{cu} login" do
			login_as send(cu)
			get :index
			assert_response :success
			assert_template 'index'
		end

		test "should destroy with #{cu} login" do
			login_as send(cu)
			assert_difference("Group.count", -1) {
				delete :destroy, :id => @membership.group.id
			}
			assert assigns(:group)
			assert_redirected_to groups_path
		end

		test "should NOT destroy with #{cu} login and invalid id" do
			login_as send(cu)
			assert_difference("Group.count", 0) {
				delete :destroy, :id => 0
			}
			assert !assigns(:group)
			assert_redirected_to groups_path
		end

		#	in rake test:coverage, 'sometimes' the Group.all is empty?????
		Group.all.each do |group|

			#	show all groups to fully test group menu
			test "should show group #{group.id} with #{cu} login" do
				login_as send(cu)
				get :show, :id => group.id
				assert_response :success
				assert_template 'show'
			end

		end

	end

	non_site_administrators.each do |cu|

		test "should NOT get new group with #{cu} login" do
			login_as send(cu)
			get :new
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end
	
		test "should NOT create group with #{cu} login" do
			login_as send(cu)
			assert_difference('Group.count',0) do
				post :create, :group => factory_attributes
			end
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT get index with #{cu} login" do
			login_as send(cu)
			get :index
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT destroy with #{cu} login" do
			login_as send(cu)
			assert_difference("Group.count", 0) {
				delete :destroy, :id => @membership.group.id
			}
			assert assigns(:group)
			assert_redirected_to root_path
		end

	end

	group_moderators.each do |cu|

		test "should edit group with #{cu} login" do
			login_as send(cu)
			get :edit, :id => @membership.group.id
			assert_response :success
			assert_template 'edit'
		end

		test "should update group with #{cu} login" do
			login_as send(cu)
			assert_changes("Group.find(#{@membership.group.id}).updated_at") {
				sleep 1	#	gotta pause so that updated_at is actually different
				put :update, :id => @membership.group.id, 
					:group => factory_attributes
			}
			assert_not_nil flash[:notice]
			assert_redirected_to groups_path
		end
	
		test "should NOT update group with #{cu} login when update fails" do
			group = @membership.group
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
			group = @membership.group
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
	non_group_moderators.each do |cu|

		test "should NOT edit group with #{cu} login" do
			login_as send(cu)
			get :edit, :id => @membership.group.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT update group with #{cu} login" do
			login_as send(cu)
			deny_changes("Group.find(#{@membership.group.id}).updated_at") {
				put :update, :id => @membership.group.id, 
					:group => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end
	
	end

	group_readers.each do |cu|

		test "should read with #{cu} login" do
			login_as send(cu)
			get :show, :id => @membership.group.id
			assert assigns(:group)
			assert_response :success
			assert_template 'show'
		end

		test "should NOT read with #{cu} login and invalid id" do
			login_as send(cu)
			get :show, :id => 0
			assert !assigns(:group)
			assert_redirected_to groups_path
		end

	end
	non_group_readers.each do |cu|

		test "should NOT read with #{cu} login" do
			login_as send(cu)
			get :show, :id => @membership.group.id
			assert assigns(:group)
			assert_redirected_to new_group_membership_path(assigns(:group))
		end

	end

end
