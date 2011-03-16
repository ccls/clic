require 'test_helper'

class TopicTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_require_unique(:title)
	assert_should_initially_belong_to(:user)
	assert_should_initially_belong_to(:forum)
	assert_should_have_many(:posts)

	test "should create topic" do
		assert_difference('User.count') {
		assert_difference('Group.count') {
		assert_difference('Forum.count') {
		assert_difference('Topic.count') {
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		} } } }
	end

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

end
