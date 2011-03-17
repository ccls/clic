require 'test_helper'

class PostsControllerTest < ActionController::TestCase

	#	no topic_id
	assert_no_route(:get,:index)
	assert_no_route(:get,:new)
	assert_no_route(:post,:create)

	#	no id
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	def factory_attributes(options={})
		Factory.attributes_for(:post,options)
	end

	setup :create_a_membership

#
#	NO Group Forum Topic Post
#

	%w( super_user admin editor ).each do |cu|

		test "should get new post with #{cu} login" do
			login_as send(cu)
			topic = create_topic
			get :new, :topic_id => topic.id
			assert_response :success
			assert_template 'new'
		end

		test "should create new post with #{cu} login" do
			login_as user = send(cu)
			topic = create_topic
			assert_difference("Forum.find(#{topic.forum.id}).posts_count",1) {
			assert_difference("Topic.find(#{topic.id}).posts_count",1) {
			assert_difference("User.find(#{user.id}).posts_count",1) {
			assert_difference('Post.count',1) {
				post :create, :topic_id => topic.id, :post => factory_attributes
			} } } }
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_not_nil flash[:notice]
			assert_redirected_to topic_path(topic)
		end

		test "should NOT create new post with #{cu} login when create fails" do
			login_as send(cu)
			topic = create_topic
			Post.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Post.count',0) do
				post :create, :topic_id => topic.id, :post => factory_attributes
			end
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new post with #{cu} login and invalid post" do
			login_as send(cu)
			topic = create_topic
			Post.any_instance.stubs(:valid?).returns(false)
			assert_difference('Post.count',0) do
				post :create, :topic_id => topic.id, :post => factory_attributes
			end
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

	end

	%w( reader active_user group_roleless group_reader
			group_administrator group_moderator group_editor 
			nonmember_administrator nonmember_moderator nonmember_editor
			nonmember_reader nonmember_roleless ).each do |cu|

		test "should NOT get new post with #{cu} login" do
			login_as send(cu)
			topic = create_topic
			get :new, :topic_id => topic.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT create new post with #{cu} login" do
			login_as send(cu)
			topic = create_topic
			assert_difference('Post.count',0) do
				post :create, :topic_id => topic.id, :post => factory_attributes
			end
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

#
#	Group Forum Topic Post
#

	%w( super_user admin group_administrator group_moderator
			group_editor ).each do |cu|

		test "should get new group post with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			get :new, :topic_id => topic.id
			assert_response :success
			assert_template 'new'
		end

		test "should create new group post with #{cu} login" do
			login_as user = send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			assert_difference("Forum.find(#{forum.id}).posts_count",1) {
			assert_difference("Topic.find(#{topic.id}).posts_count",1) {
			assert_difference("User.find(#{user.id}).posts_count",1) {
			assert_difference('Post.count',1) {
				post :create, :topic_id => topic.id, :post => factory_attributes
			} } } }
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_not_nil flash[:notice]
			assert_redirected_to topic_path(topic)
		end

		test "should NOT create new group post with #{cu} login when create fails" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			Post.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Post.count',0) do
				post :create, :topic_id => topic.id, :post => factory_attributes
			end
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new group post with #{cu} login and invalid topic" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			Post.any_instance.stubs(:valid?).returns(false)
			assert_difference('Post.count',0) do
				post :create, :topic_id => topic.id, :post => factory_attributes
			end
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

	end

	%w( editor reader active_user group_roleless group_reader
			nonmember_administrator nonmember_moderator nonmember_editor
			nonmember_reader nonmember_roleless ).each do |cu|

		test "should NOT get new group post with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			get :new, :topic_id => topic.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT create new group post with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			assert_difference('Post.count',0) do
				post :create, :topic_id => topic.id, :post => factory_attributes
			end
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end


protected

	def create_group_forum(group)
		forum = Factory(:forum, :group => group)
		assert_not_nil forum.id
		assert_not_nil forum.group
		forum
	end

	def create_forum_topic(forum)
		topic = Factory(:topic, :forum => forum)
		assert_not_nil topic.id 
		assert_not_nil topic.forum
		assert_not_nil topic.user
		topic
	end

	def create_forum_topic_post(topic)
		post = Factory(:post, :topic => topic)
		assert_not_nil post.id 
		assert_not_nil post.topic
		assert_not_nil post.user
		post
	end

end
