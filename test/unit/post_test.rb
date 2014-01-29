require 'test_helper'

class PostTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:body)
	assert_should_initially_belong_to(:user)
	assert_should_initially_belong_to(:topic)
	assert_should_have_many(:group_documents, :as => :attachable)
	assert_should_require_attribute_length( :body,  :maximum => 65000 )

	assert_should_protect(:user_id, :topic_id)

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

	test "should increment posts_count on create" do
		topic = create_topic
		user = topic.user
		assert_difference("User.find(#{user.id}).posts_count",1) {
		assert_difference("Forum.find(#{topic.forum.id}).posts_count",1) {
		assert_difference("Topic.find(#{topic.id}).posts_count",1) {
		assert_difference('Post.count',1) {
			object = create_object(:topic => topic, :user => user)
		} } } }
	end

	test "should return first 10 of body as to_s" do
		object = create_object
		assert_equal object.body[0..9], "#{object}"
	end

	test "should create post with nested attributes for group_documents" do
		topic = FactoryGirl.create(:topic)
		assert_difference('Topic.count',0) {
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',1) {
		assert_difference('Post.count',1) {
			object = create_post( {
				:topic => topic, :user => topic.user,
				:group_documents_attributes => [
					group_doc_attributes_with_attachment
			]})
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal topic.user, object.user
			assert_equal topic.user, object.group_documents.first.user
			assert_equal          1, object.group_documents.length
		} } } }
		remove_object_with_group_documents(topic.reload.posts.first)
	end

	test "should NOT create post with nested attributes for group_documents" <<
			" without user" do
		topic = FactoryGirl.create(:topic)
		assert_difference('Topic.count',0) {
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',0) {
		assert_difference('Post.count',0) {
			object = create_post( {
				:topic => topic, 
				:user => nil,		#	needs to be explicitly nil otherwise factory will add one
				:group_documents_attributes => [
					group_doc_attributes_with_attachment
			]})
			assert object.errors.matching?('group_documents.user_id',:blank)
		} } } }
	end

	test "should destroy group_document with post" do	#	doesn't really do it in testing anymore?
		object = create_post( {
			:group_documents_attributes => [
				group_doc_attributes_with_attachment
		]})
		assert_difference("Forum.find(#{object.topic.forum.id}).posts_count",-1) {
		assert_difference("Topic.find(#{object.topic.id}).posts_count",-1) {
		assert_difference('GroupDocument.count',-1) {
		assert_difference('Post.count',-1) {
			remove_object_with_group_documents(object)
			object.destroy
		} } } }
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_post

end
