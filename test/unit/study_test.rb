require 'test_helper'

class StudyTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:name)
	assert_should_require_unique(:name)
	assert_should_act_as_list
	assert_should_belong_to(:publication)

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

end
