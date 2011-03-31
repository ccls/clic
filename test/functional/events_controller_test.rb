require 'test_helper'

class EventsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Event',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_event
	}
	def factory_attributes(options={})
		Factory.attributes_for(:event,options)
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

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
		:logins => (ALL_TEST_ROLES - creators),
		:actions => [:edit,:update,:destroy] })

	assert_access_with_login({ 
		:logins => creators,
		:actions => [:new,:create] })

	assert_no_access_with_login({ 
		:logins => (ALL_TEST_ROLES - creators),
		:actions => [:new,:create],
		:redirect => :members_only_path })

	assert_access_with_login({ 
		:logins => ( ALL_TEST_ROLES - unapproved_users ),
		:actions => [:show,:index] })

	assert_no_access_with_login({ 
		:logins => unapproved_users,
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
		:redirect => :events_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

	creators.each do |cu|

		test "should create new event with #{cu} login and begin and end times" do
			login_as send(cu)
			assert_difference('Event.count',1) do
				post :create, :event => factory_attributes.merge({
					:begins_on => 'May 12, 2000',
					:ends_on => 'December 5, 2000',
					:begins_at_hour => "12",
					:begins_at_minute => "35",
					:begins_at_meridiem => 'pm',
					:ends_at_hour => "5",
					:ends_at_minute => "0",
					:ends_at_meridiem => 'pm' })
			end
			assert assigns(:event)
			assert_equal '5/12/2000 ( 12:35 PM ) - 12/5/2000 ( 5:00 PM )', assigns(:event).time
			assert_redirected_to members_only_path
			assert_not_nil flash[:notice]
		end

		test "should NOT create new event with #{cu} login when create fails" do
			Event.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('Event.count',0) do
				post :create, :event => factory_attributes
			end
			assert assigns(:event)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end
	
		test "should NOT create new event with #{cu} login and invalid event" do
			Event.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			assert_difference('Event.count',0) do
				post :create, :event => factory_attributes
			end
			assert assigns(:event)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end
	
		test "should NOT update event with #{cu} login when update fails" do
			event = create_event(:updated_at => Chronic.parse('yesterday'))
			Event.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("Event.find(#{event.id}).updated_at") {
				put :update, :id => event.id,
					:event => factory_attributes
			}
			assert assigns(:event)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
		test "should NOT update event with #{cu} login and invalid event" do
			event = create_event(:updated_at => Chronic.parse('yesterday'))
			Event.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("Event.find(#{event.id}).updated_at") {
				put :update, :id => event.id,
					:event => factory_attributes
			}
			assert assigns(:event)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
	end

end
