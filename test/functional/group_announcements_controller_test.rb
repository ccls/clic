require 'test_helper'

class GroupAnnouncementsControllerTest < ActionController::TestCase

	def factory_attributes(options={})
		FactoryGirl.attributes_for(:group_announcement)
	end

	def create_group_object(options={})
		FactoryGirl.create(:group_announcement, options)
	end

	add_strong_parameters_tests(:announcement, 
		[ :title, :location, :content, :begins_on, :begins_at_hour, :begins_at_minute, 
			:begins_at_meridiem, :ends_on, :ends_at_hour, :ends_at_minute, :ends_at_meridiem])

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	#	no group_id
	assert_no_route(:get,:index)
	assert_no_route(:get,:new)
	assert_no_route(:post,:create)

	#	no id
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	def self.group_asset_readers
		@group_asset_readers ||= (group_asset_editors + %w(group_reader))
	end
	def self.group_asset_editors
		@group_asset_editors ||= (group_asset_destroyers + %w(group_editor))
	end
	def self.group_asset_destroyers
		@group_asset_destroyers ||= %w( superuser administrator group_moderator )
	end

	############################################################

	#
	#	Full (destroy) access roles
	#
	group_asset_destroyers.each do |cu|

		test "should destroy announcement with #{cu} login" do
			object = create_group_object(:group => @membership.group)
			assert object.is_a?(Announcement)
			login_as send(cu)
			assert_difference("Announcement.count",-1){
				delete :destroy, 
					:group_id => @membership.group.id, 
					:id => object.id
			}
			assert_redirected_to group_path(object.group)
		end

		test "should NOT destroy announcement with #{cu} login " <<
				"and without group" do
			object = create_group_object(:group => nil)
			assert object.is_a?(Announcement)
			assert_nil object.reload.group
			login_as send(cu)
			assert_difference("Announcement.count",0){
				delete :destroy, 
					:group_id => @membership.group.id, 
					:id => object.id
			}
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should NOT destroy announcement with #{cu} login " <<
				"and invalid id" do
			login_as send(cu)
			assert_difference("Announcement.count",0){
				delete :destroy, 
					:group_id => @membership.group.id, 
					:id => 0
			}
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

	end	#	Full (destroy) access roles

	#
	#	No destroy access roles
	#
	( all_test_roles - group_asset_destroyers ).each do |cu|

		test "should NOT destroy announcement with #{cu} login" do
			object = create_group_object(:group => @membership.group)
			assert object.is_a?(Announcement)
			login_as send(cu)
			assert_difference("Announcement.count",0){
				delete :destroy, 
					:group_id => @membership.group.id, 
					:id => object.id
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path	#	members_only_path
		end

	end	#	No destroy access roles

	############################################################

	#
	#	Edit access roles
	#
	group_asset_editors.each do |cu|

		test "should get new announcement with #{cu} login" do
			login_as send(cu)
			get :new, :group_id => @membership.group.id
			assert_response :success
			assert_template 'new'
		end

		test "should NOT get new announcement with #{cu} login " <<
				"and without valid group" do
			login_as send(cu)
			get :new, :group_id => 0
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should create announcement with #{cu} login" do
			login_as user = send(cu)
			assert_difference("Announcement.count",1){
				post :create, :group_id => @membership.group.id, 
					:announcement => factory_attributes
			}
			assert       assigns(:announcement)
			assert_equal assigns(:announcement).user,  user
			assert_equal assigns(:announcement).group, @membership.group
			assert_redirected_to group_path(@membership.group)
		end

		test "should NOT create announcement with #{cu} login " <<
				"and without valid group" do
			login_as send(cu)
			assert_difference("Announcement.count",0){
				post :create, :group_id => 0, 
					:announcement => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should NOT create announcement with #{cu} login " <<
				"when create fails" do
			Announcement.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference("Announcement.count",0) do
				post :create, :group_id => @membership.group.id, 
					:announcement => factory_attributes
			end
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create announcement with #{cu} login " <<
				"and invalid announcement" do
			Announcement.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			assert_difference("Announcement.count",0) do
				post :create, :group_id => @membership.group.id, 
					:announcement => factory_attributes
			end
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should edit announcement with #{cu} login" do
			object = create_group_object(:group => @membership.group)
			assert object.is_a?(Announcement)
			login_as send(cu)
			get :edit, :group_id => @membership.group.id, :id => object.id
			assert_response :success
			assert_template 'edit'
		end

		test "should NOT edit announcement with #{cu} login " <<
				"without valid id" do
			login_as send(cu)
			get :edit, :group_id => @membership.group.id, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should NOT edit announcement with #{cu} login " <<
				"and without group" do
			object = create_group_object(:group => nil)
			assert object.is_a?(Announcement)
			assert_nil object.reload.group
			login_as send(cu)
			get :edit, :group_id => @membership.group.id, :id => object.id
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should update announcement with #{cu} login" do
			object = create_group_object(:group => @membership.group,:updated_at => Date.yesterday)
			assert object.is_a?(Announcement)
			assert_equal object.group, @membership.group
			sleep 1
			login_as send(cu)
			assert_changes("Announcement.find(#{object.id}).updated_at") {
				put :update, :group_id => @membership.group.id, :id => object.id, 
					:announcement => factory_attributes
			}
			assert_redirected_to group_path(@membership.group)
		end

		test "should NOT update groupless announcement with #{cu} login" do
			object = create_group_object(:group => nil,:updated_at => Date.yesterday)
			assert object.is_a?(Announcement)
			assert_nil object.reload.group
			login_as send(cu)
			deny_changes("Announcement.find(#{object.id}).updated_at") {
				put :update, :group_id => @membership.group.id, :id => object.id, 
					:announcement => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should NOT update announcement with #{cu} login " <<
				"when update fails" do
			object = create_group_object(:group => @membership.group,:updated_at => Date.yesterday)
			assert object.is_a?(Announcement)
			Announcement.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("Announcement.find(#{object.id}).updated_at") {
				put :update, :group_id => @membership.group.id, :id => object.id, 
					:announcement => factory_attributes
			}
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

		test "should NOT update announcement with #{cu} login " <<
				"and invalid announcement" do
			object = create_group_object(:group => @membership.group,:updated_at => Date.yesterday)
			assert object.is_a?(Announcement)
			Announcement.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("Announcement.find(#{object.id}).updated_at") {
				put :update, :group_id => @membership.group.id, :id => object.id, 
					:announcement => factory_attributes
			}
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

		test "should NOT update announcement with #{cu} login " <<
				"and invalid id" do
			login_as send(cu)
			put :update, :group_id => @membership.group.id, :id => 0, 
				:announcement => factory_attributes
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

	end	#	Edit access roles

	#
	#	No edit access roles
	#
	( all_test_roles - group_asset_editors ).each do |cu|

		test "should NOT get new announcement with #{cu} login" do
			login_as send(cu)
			get :new, :group_id => @membership.group.id
			assert_redirected_to root_path
		end

		test "should NOT create announcement with #{cu} login" do
			login_as send(cu)
			assert_difference("Announcement.count",0){
				post :create, :group_id => @membership.group.id, 
					:announcement => factory_attributes
			}
			assert_redirected_to root_path
		end

		test "should NOT edit announcement with #{cu} login" do
			object = create_group_object(:group => @membership.group)
			assert object.is_a?(Announcement)
			login_as send(cu)
			get :edit, :group_id => @membership.group.id, :id => object.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT update announcement with #{cu} login" do
			object = create_group_object(:group => @membership.group,:updated_at => Date.yesterday)
			assert object.is_a?(Announcement)
			login_as send(cu)
			deny_changes("Announcement.find(#{object.id}).updated_at") {
				put :update, :group_id => @membership.group.id, :id => object.id, 
					:announcement => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end	#	No edit access roles

	############################################################

	#
	#	Read access roles
	#
	group_asset_readers.each do |cu|

		test "should show announcement with #{cu} login" do
			object = create_group_object(:group => @membership.group)
			assert object.is_a?(Announcement)
			login_as send(cu)
			get :show, :group_id => @membership.group.id, :id => object.id
			assert_response :success
			assert_template 'show'
		end

		test "should get all announcements with #{cu} login" do
			login_as send(cu)
			get :index, :group_id => @membership.group.id
			assert_response :success
			assert_template 'index'
		end

	end	#	Read access roles

	#
	#	No access roles ( No read access roles )
	#
	( all_test_roles - group_asset_readers ).each do |cu|

		test "should NOT show announcement with #{cu} login" do
			object = create_group_object(:group => @membership.group)
			assert object.is_a?(Announcement)
			login_as send(cu)
			get :show, 
				:group_id => @membership.group.id, 
				:id => object.id
			assert_not_nil flash[:error]
			assert_redirected_to new_group_membership_path(@membership.group)
		end

		test "should NOT get index announcements with #{cu} login" do
			login_as send(cu)
			get :index, :group_id => @membership.group.id
			assert_not_nil flash[:error]
			assert_redirected_to new_group_membership_path(@membership.group)
		end

	end	#	No access roles

	############################################################

	#
	#	No login
	#
	test "should NOT get new announcement without login" do
		get :new, 
			:group_id => @membership.group.id
		assert_redirected_to_login
	end

	test "should NOT create announcement without login" do
		assert_difference("Announcement.count",0){
			post :create, 
				:group_id => @membership.group.id, 
				:announcement => factory_attributes
		}
		assert_redirected_to_login
	end

	test "should NOT edit announcement without login" do
		object = create_group_object(:group => @membership.group)
		assert object.is_a?(Announcement)
		get :edit, :group_id => @membership.group.id, :id => object.id
		assert_redirected_to_login
	end

	test "should NOT update announcement without login" do
		object = create_group_object(:group => @membership.group,:updated_at => Date.yesterday)
		assert object.is_a?(Announcement)
		sleep 1
		deny_changes("Announcement.find(#{object.id}).updated_at") {
			put :update, 
				:group_id => @membership.group.id, 
				:id => object.id, 
				:announcement => factory_attributes
		}
		assert_redirected_to_login
	end

	test "should NOT destroy announcement without login" do
		object = create_group_object(:group => @membership.group)
		assert object.is_a?(Announcement)
		assert_difference("Announcement.count",0){
			delete :destroy, 
				:group_id => @membership.group.id, 
				:id => object.id
		}
		assert_redirected_to_login
	end

	test "should NOT get index announcements without login" do
		get :index, :group_id => @membership.group.id
		assert_redirected_to_login
	end

	test "should NOT show announcement without login" do
		object = create_group_object(:group => @membership.group)
		assert object.is_a?(Announcement)
		get :show, 
			:group_id => @membership.group.id, 
			:id => object.id
		assert_redirected_to_login
	end	#	End No login
	
end
