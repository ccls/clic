require 'test_helper'

class AnnouncementsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Announcement',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_announcement
	}
	def factory_attributes(options={})
		Factory.attributes_for(:announcement,options)
	end

	def self.creators
		@creators ||= site_administrators
	end

	def self.editors
		@editors ||= creators
	end

	assert_access_with_login({ 
		:logins => editors,
		:actions => [:edit,:update,:destroy] })

	assert_no_access_with_login({ 
		:logins => (ALL_TEST_ROLES - editors),
		:actions => [:edit,:update,:destroy] })

	assert_access_with_login({ 
		:logins => creators,
		:actions => [:new,:create] })

	assert_no_access_with_login({ 
		:logins => (ALL_TEST_ROLES - creators),
		:actions => [:new,:create],
		:redirect => :members_only_path })

	assert_access_with_login({ 
		:logins => ALL_TEST_ROLES,
		:actions => [:show,:index] })

	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :announcements_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	creators.each do |cu|

		test "should NOT create new announcement with #{cu} login when create fails" do
			Announcement.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('Announcement.count',0) do
				post :create, :announcement => factory_attributes
			end
			assert assigns(:announcement)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end
	
		test "should NOT create new announcement with #{cu} login and invalid announcement" do
			Announcement.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			assert_difference('Announcement.count',0) do
				post :create, :announcement => factory_attributes
			end
			assert assigns(:announcement)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end
	
		test "should NOT update announcement with #{cu} login when update fails" do
			announcement = create_announcement(:updated_at => Chronic.parse('yesterday'))
			Announcement.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("Announcement.find(#{announcement.id}).updated_at") {
				put :update, :id => announcement.id,
					:announcement => factory_attributes
			}
			assert assigns(:announcement)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
		test "should NOT update announcement with #{cu} login and invalid announcement" do
			announcement = create_announcement(:updated_at => Chronic.parse('yesterday'))
			Announcement.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("Announcement.find(#{announcement.id}).updated_at") {
				put :update, :id => announcement.id,
					:announcement => factory_attributes
			}
			assert assigns(:announcement)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
	end

	test "should NOT show announcement if has group" do
		announcement = Factory(:group_announcement)
		login_as admin
		get :show, :id => announcement.id
		assert_not_nil flash[:error]
		assert_redirected_to members_only_path
	end

end
