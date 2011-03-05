require 'test_helper'

class ForumTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:name)
	assert_should_require_unique(:name)
	assert_should_initially_belong_to(:group)
	assert_should_have_many(:topics)

	test "should create forum" do
		assert_difference('Group.count') {
		assert_difference('Forum.count') {
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		} }
	end

end
