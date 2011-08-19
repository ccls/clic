require 'test_helper'

class GroupAnnouncementsControllerTest < ActionController::TestCase

	assert_nested_group_asset(
		:model   => 'Announcement',
		:factory => :group_announcement,
		:attributes_key => :announcement
	)

	def factory_attributes(options={})
		Factory.attributes_for(:group_announcement,options)
	end

	def create_group_object(options={})
		Factory(:group_announcement, options)
	end

end
