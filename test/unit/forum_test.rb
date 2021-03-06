require 'test_helper'

class ForumTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:name)
	assert_should_require_unique(:name, :scope => :group_id)
	assert_should_belong_to(:group)
	assert_should_have_many(:topics)
	assert_should_require_attribute_length( :name,  :maximum => 250 )
#	assert_should_protect(:group_id)

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

	test "should return only those not associated to a group" do
		create_object(:group => FactoryGirl.create(:group))
		create_object(:group => nil)
		assert Forum.groupless.length > 0
		Forum.groupless.each do |groupless|
			assert_nil groupless.group_id
		end
	end

	test "should increment posts_count with post creation" do
		forum = create_forum
		topic = create_topic(:forum => forum)
		post = FactoryGirl.create(:post, :topic => topic)
		assert_equal 1, post.topic.forum.reload.posts_count
		assert_difference("Forum.find(#{post.topic.forum.id}).posts_count",1) do
			FactoryGirl.create(:post, :topic => post.topic)
		end
		assert_equal 2, post.topic.forum.reload.posts_count
	end

	test "should decrement posts_count with post destruction" do
		forum = create_forum
		topic = create_topic(:forum => forum)
		post = FactoryGirl.create(:post, :topic => topic)
		assert_equal 1, post.topic.forum.reload.posts_count
		assert_difference("Forum.find(#{post.topic.forum.id}).posts_count",-1) do
			post.destroy
		end
	end

	test "should have a last_post" do
		post = FactoryGirl.create(:post)
		assert_equal post, post.topic.forum.last_post
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_forum

end
