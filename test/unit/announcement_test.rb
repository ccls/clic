require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_require_attribute_length( :title,   :maximum => 250 )
	assert_should_require(:content)
	assert_should_require_attribute_length( :content, :maximum => 65000 )

	assert_should_not_require(:begins_on)
	assert_should_not_require(:begins_at_hour)
	assert_should_not_require(:begins_at_minute)
	assert_should_not_require(:begins_at_meridiem)
	assert_should_not_require(:ends_on)
	assert_should_not_require(:ends_at_hour)
	assert_should_not_require(:ends_at_minute)
	assert_should_not_require(:ends_at_meridiem)
	assert_requires_complete_date( :begins_on )
	assert_requires_complete_date( :ends_on )

	assert_should_initially_belong_to( :user )
	assert_should_belong_to( :group )
#	assert_should_protect(:group_id)
#	assert_should_protect(:user_id)

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

	test "should return only those not associated to a group" do
		create_object(:group => FactoryGirl.create(:group))
		create_object(:group => nil)
		assert Announcement.groupless.length > 0
		Announcement.groupless.each do |groupless|
			assert_nil groupless.group_id
		end
	end

	test "should return formatted begin date" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_object(:begins_on => 'May 12, 2000')
			assert_equal '5/12/2000', object.begins
		end
	end

	test "should return formatted begin date with time" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_announcement_with_times(:begins_on => 'May 12, 2000')
			assert_equal '5/12/2000 ( 12:35 PM )', object.begins
		end
	end

	test "should return formatted end date" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_object(:ends_on => 'May 12, 2000')
			assert_equal '5/12/2000', object.ends
		end
	end

	test "should return formatted end date with time" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_announcement_with_times(:ends_on => 'May 12, 2000')
			assert_equal '5/12/2000 ( 5:00 PM )', object.ends
		end
	end

	test "should return announcement time with begins_on" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_object(:begins_on => 'May 12, 2000')
			assert_equal '5/12/2000', object.time
		end
	end

	test "should return announcement time with begins_on and ends_on" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_object(:begins_on => 'May 12, 2000',
				:ends_on => 'December 5, 2000' )
			assert_equal '5/12/2000 - 12/5/2000', object.time
		end
	end

	test "should return announcement time with begins_on, begins_at and ends_on" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_announcement_with_times(:begins_on => 'May 12, 2000',
				:ends_on => 'December 5, 2000',
				:ends_at_hour => nil,
				:ends_at_minute => nil,
				:ends_at_meridiem => nil )
			assert_equal '5/12/2000 ( 12:35 PM ) - 12/5/2000', object.time
		end
	end

	test "should return announcement time with begins_on, begins_at, ends_on and ends_at" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_announcement_with_times(:begins_on => 'May 12, 2000',
				:ends_on => 'December 5, 2000' )
			assert_equal '5/12/2000 ( 12:35 PM ) - 12/5/2000 ( 5:00 PM )', object.time
		end
	end

	test "should return begins_at from begins_at_ fields" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_announcement_with_times
			assert_equal '12:35 PM', object.begins_at
		end
	end

	test "should return ends_at from ends_at_ fields" do
		assert_difference( "Announcement.count", 1 ) do
			object = create_announcement_with_times
			assert_equal '5:00 PM', object.ends_at
		end
	end

	test "should require begins_at_hour greater than 0" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:begins_at_hour => 0)
			assert object.errors.matching?(:begins_at_hour,
				'is not included in the list')
		end
	end

	test "should require begins_at_hour less than 13" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:begins_at_hour => 13)
			assert object.errors.matching?(:begins_at_hour,
				'is not included in the list')
		end
	end

	test "should require begins_at_minute greater than -1" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:begins_at_minute => -1)
			assert object.errors.matching?(:begins_at_minute,
				'is not included in the list')
		end
	end

	test "should require begins_at_minute less than 60" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:begins_at_minute => 60)
			assert object.errors.matching?(:begins_at_minute,
				'is not included in the list')
		end
	end

	test "should require begins_at_meridiem is AM or PM" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:begins_at_meridiem => "MM")
			assert object.errors.matching?(:begins_at_meridiem,:invalid)
		end
	end


	test "should require ends_at_hour greater than 0" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:ends_at_hour => 0)
			assert object.errors.matching?(:ends_at_hour,
				'is not included in the list')
		end
	end

	test "should require ends_at_hour less than 13" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:ends_at_hour => 13)
			assert object.errors.matching?(:ends_at_hour,
				'is not included in the list')
		end
	end

	test "should require ends_at_minute greater than -1" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:ends_at_minute => -1)
			assert object.errors.matching?(:ends_at_minute,
				'is not included in the list')
		end
	end

	test "should require ends_at_minute less than 60" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:ends_at_minute => 60)
			assert object.errors.matching?(:ends_at_minute,
				'is not included in the list')
		end
	end

	test "should require ends_at_meridiem is AM or PM" do
		assert_difference( "Announcement.count", 0 ) do
			object = create_announcement_with_times(:ends_at_meridiem => "MM")
			assert object.errors.matching?(:ends_at_meridiem,:invalid)
		end
	end

	test "should allow ends_on be the same as begins_on" do
		assert_difference( 'Announcement.count', 1 ) do
			object = create_object(
				:begins_on => Date.yesterday,
				:ends_on   => Date.yesterday
			)
		end
	end

	test "should allow ends_at be the same as begins_at" do
		assert_difference( 'Announcement.count', 1 ) do
			object = create_object(
				:begins_on => Date.yesterday,
				:begins_at_hour => 5,
				:begins_at_minute => 0,
				:begins_at_meridiem => 'pm',
				:ends_on   => Date.yesterday,
				:ends_at_hour => 5,
				:ends_at_minute => 0,
				:ends_at_meridiem => 'pm'
			)
		end
	end

	test "should require ends_on be on or after begins_on" do
		assert_difference( 'Announcement.count', 0 ) do
			object = create_object(
				:begins_on => Date.tomorrow,
				:ends_on   => Date.yesterday
			)
			assert object.errors.include?(:ends_on)
			assert object.errors.matching?(:ends_on, 'after begins_on')
		end
	end

	test "should require begins_on if ends_on" do
		assert_difference( 'Announcement.count', 0 ) do
			object = create_object(
				:begins_on => nil,
				:ends_on   => Date.yesterday
			)
			assert object.errors.include?(:begins_on)
			assert object.errors.matching?(:begins_on, 'be blank')
		end
	end

protected

	def create_announcement_with_times(options={})
		object = create_object({
			:begins_at_hour => 12,
			:begins_at_minute => 35,
			:begins_at_meridiem => 'pm',
			:ends_at_hour => 5,
			:ends_at_minute => 0,
			:ends_at_meridiem => 'pm' }.merge(options))
		object
	end

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_announcement

end
