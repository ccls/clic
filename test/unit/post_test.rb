require 'test_helper'

class PostTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:body)
	assert_should_initially_belong_to(:user)
	assert_should_initially_belong_to(:topic)
	assert_should_have_many(:group_documents, :as => :attachable)
	assert_should_require_attribute_length( :body,  :maximum => 65000 )

	test "should create post" do
		assert_difference('User.count',2) {
		assert_difference('Forum.count') {
		assert_difference('Topic.count') {
		assert_difference('Post.count') {
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		} } } }
	end

	test "should return first 10 of body as to_s" do
		object = create_object
		assert_equal object.body[0..9], "#{object}"
	end

	test "should create post with nested attributes for group_documents" do
		topic = Factory(:topic)
		assert_difference('Topic.count',0) {
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',1) {
		assert_difference('Post.count',1) {
			object = Factory(:post, {
				:topic => topic, :user => topic.user,
				:group_documents_attributes => [
					Factory.attributes_for(:group_document,
						:document => File.open(File.dirname(__FILE__) + 
							'/../assets/edit_save_wireframe.pdf'))
			]})
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal topic.user, object.user
			assert_equal topic.user, object.group_documents.first.user
		} } } }
		GroupDocument.destroy_all
	end

end
