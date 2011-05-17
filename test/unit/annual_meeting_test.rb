require 'test_helper'

class AnnualMeetingTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:meeting)
	assert_should_require(:abstract)

	test "should return meeting as to_s" do
		object = create_object
		assert_equal object.meeting, "#{object}"
	end

end
