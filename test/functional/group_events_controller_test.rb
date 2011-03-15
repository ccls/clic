require 'test_helper'

class GroupEventsControllerTest < ActionController::TestCase

	assert_nested_group_asset(
		:model   => 'Event',
		:factory => :group_event,
		:attributes_key => :event
	)

	def factory_attributes(options={})
		Factory.attributes_for(:group_event)
	end

	def create_group_object(options={})
		Factory(:group_event, options)
	end

end
