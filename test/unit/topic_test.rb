require 'test_helper'

class TopicTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_initially_belong_to(:user)
	assert_should_initially_belong_to(:forum)
	assert_should_have_many(:posts)
	assert_should_require_attribute_length( :title, :maximum => 250 )
#	assert_should_protect(:user_id, :forum_id)

	test "should create topic" do
		assert_difference('User.count') {
		assert_difference('Forum.count') {
		assert_difference('Topic.count') {
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		} } }
	end

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

	test "should create topic with nested attributes for posts" do
		user = FactoryGirl.create(:user)
		assert_difference('Topic.count',1) {
		assert_difference('User.count',0) {
		assert_difference('Post.count',1) {
			object = FactoryGirl.create(:topic, {
				:user => user,
				:posts_attributes => [ FactoryGirl.attributes_for(:post) ]
			})
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal user, object.user
			assert_equal user, object.posts.first.user
			assert_equal    1, object.posts.length
		} } }
	end

	test "should create topic with nested attributes for posts and " <<
			"nested attributes for group_documents" do
		user = FactoryGirl.create(:user)
		assert_difference('Topic.count',1) {
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',1) {
		assert_difference('Post.count',1) {
			object = FactoryGirl.create(:topic, {
				:user => user,
				:posts_attributes => [FactoryGirl.attributes_for(:post,
					:group_documents_attributes => [
						group_doc_attributes_with_attachment
					])
			]})
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal user, object.user
			assert_equal user, object.posts.first.user
			assert_equal    1, object.posts.length
			assert_equal user, object.posts.first.group_documents.first.user
			assert_equal    1, object.posts.first.group_documents.length
		} } } }
		remove_object_with_group_documents(user.posts.first)
	end

	test "should create topic with nested attributes for posts and " <<
			"nested attributes for group_documents with group" do
		group = FactoryGirl.create(:group)
		forum = FactoryGirl.create(:forum, :group => group)
		assert_not_nil forum.group
		user = FactoryGirl.create(:user)
		assert_difference('Topic.count',1) {
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',1) {
		assert_difference('Post.count',1) {
			object = FactoryGirl.create(:topic, {
				:forum => forum,
				:user => user,
				:posts_attributes => [FactoryGirl.attributes_for(:post,
					:group_documents_attributes => [
						group_doc_attributes_with_attachment
					])
			]})
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal forum, object.forum
			assert_equal group, object.forum.group
			assert_equal  user,  object.user
			assert_equal  user,  object.posts.first.user
			assert_equal     1,  object.posts.length
			assert_equal  user,  object.posts.first.group_documents.first.user
			assert_equal group, object.posts.first.group_documents.first.group
			assert_equal     1, object.posts.first.group_documents.length
		} } } }
		remove_object_with_group_documents(user.posts.first)
	end

	test "should have a last_post" do
		post = FactoryGirl.create(:post)
		assert_equal post, post.topic.last_post
	end


protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_topic

end
