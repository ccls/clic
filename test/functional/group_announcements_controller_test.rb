require 'test_helper'

class GroupAnnouncementsControllerTest < ActionController::TestCase

	assert_nested_group_asset(
		:model   => 'Announcement',
		:factory => :group_announcement,
		:attributes_key => :announcement
	)

	def factory_attributes(options={})
		FactoryGirl.attributes_for(:group_announcement)
	end

	def create_group_object(options={})
		FactoryGirl.create(:group_announcement, options)
	end

end
