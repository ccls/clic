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

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	with_options :actions => [:edit,:update,:destroy] do |o|
		o.assert_access_with_login({    :logins => site_administrators })
		o.assert_no_access_with_login({ :logins => non_site_administrators })
	end

	with_options :actions => [:new,:create] do |o|
		o.assert_access_with_login({    :logins => site_administrators })
		o.assert_no_access_with_login({ :logins => non_site_administrators,
		:redirect => :members_only_path })
	end

	with_options :actions => [:show,:index] do |o|
		o.assert_access_with_login({    :logins => approved_users })
		o.assert_no_access_with_login({ :logins => unapproved_users })
	end

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
		:edit    => { :id => 0 },
		:update  => { :id => 0 },
		:show    => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should create new announcement with #{cu} login and begin and end times" do
			login_as send(cu)
			assert_difference('Announcement.count',1) do
				post :create, :announcement => factory_attributes.merge({
					:begins_on => 'May 12, 2000',
					:ends_on => 'December 5, 2000',
					:begins_at_hour => "12",
					:begins_at_minute => "35",
					:begins_at_meridiem => 'pm',
					:ends_at_hour => "5",
					:ends_at_minute => "0",
					:ends_at_meridiem => 'pm' })
			end
			assert assigns(:announcement)
			assert_equal '5/12/2000 ( 12:35 PM ) - 12/5/2000 ( 5:00 PM )', assigns(:announcement).time
			assert_redirected_to members_only_path
			assert_not_nil flash[:notice]
		end

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

end
