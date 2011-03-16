require 'test_helper'

class PostTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:body)
	assert_should_initially_belong_to(:user)
	assert_should_initially_belong_to(:topic)

	test "should create post" do
		assert_difference('User.count',2) {
		assert_difference('Group.count') {
		assert_difference('Forum.count') {
		assert_difference('Topic.count') {
		assert_difference('Post.count') {
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		} } } } }
	end

	test "should return first 10 of body as to_s" do
		object = create_object
		assert_equal object.body[0..9], "#{object}"
	end

end
