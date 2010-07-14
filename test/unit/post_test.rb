require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase

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

protected

	def create_object(options = {})
		record = Factory.build(:post,options)
		record.save
		record
	end

end
