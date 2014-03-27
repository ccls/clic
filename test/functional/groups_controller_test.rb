require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Group',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}
	def factory_create(options={})
#		create_group
		FactoryGirl.create(:group,options)
	end
	def factory_attributes(options={})
		FactoryGirl.attributes_for(:group,options)
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
	assert_orderable

	site_administrators.each do |cu|

		#	in rake test:coverage, 'sometimes' the Group.all is empty?????
		#	I think that this is usually after a rake db:test:prepare
		Group.all.each do |group|

			#	show all groups to fully test group menu
			test "should show group #{group.id} with #{cu} login" do
				login_as send(cu)
				get :show, :id => group.id
				assert_response :success
				assert_template 'show'
			end

			test "should get children of group #{group.id} with #{cu} login" do
				login_as send(cu)
				get :index, :parent_id => group.id
				assert_response :success
				assert_template 'index'
				assert_not_nil assigns(:group)
				assert_not_nil assigns(:groups)
			end

		end


		test "should get index of a root group with children and #{cu} login" do
			group = FactoryGirl.create(:group)
			child = FactoryGirl.create(:group, :parent_id => group.id)
			login_as send(cu)
			get :index, :parent_id => group.id
			assert_response :success
			assert_template 'index'
			assert_not_nil assigns(:group)
			assert_not_nil assigns(:groups)
			assert_equal assigns(:groups), [child]
		end

		test "should get index of a root group without children and #{cu} login" do
			group = FactoryGirl.create(:group)
			login_as send(cu)
			get :index, :parent_id => group.id
			assert_response :success
			assert_template 'index'
			assert_not_nil assigns(:group)
			assert_not_nil assigns(:groups)
			assert assigns(:groups).empty?
		end

		test "should get index of a non-root group with #{cu} login" do
			group = FactoryGirl.create(:group)
			child = FactoryGirl.create(:group, :parent_id => group.id)
			login_as send(cu)
			get :index, :parent_id => child.id
			assert_response :success
			assert_template 'index'
			assert_not_nil assigns(:group)
			assert_not_nil assigns(:groups)
			assert assigns(:groups).empty?
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
			assert assigns(:announcements)
			assert assigns(:cal_events)
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
