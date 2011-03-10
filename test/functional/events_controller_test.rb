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

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })
	assert_no_access_with_login({ 
		:logins => [:editor,:interviewer,:reader,:active_user] })
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

%w( superuser admin ).each do |cu|

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
