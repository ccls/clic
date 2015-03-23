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
		FactoryGirl.attributes_for(:post,options)
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

#
#	NO Group Forum Topic Post
#

	site_administrators.each do |cu|

		test "should edit post with #{cu} login" do
			login_as send(cu)
			post = create_post
			get :edit, :id => post.id
			assert_response :success
			assert_template 'edit'
		end

		test "should not edit post with #{cu} login and invalid id" do
			login_as send(cu)
			get :edit, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should update post with #{cu} login" do
			login_as send(cu)
			post = create_post
			sleep 1
			assert_changes("Post.find(#{post.id}).updated_at") {
				put :update, :id => post.id, :post => factory_attributes
			}
			assert_not_nil flash[:notice]
			assert_redirected_to post.topic
		end

		test "should not update post with #{cu} login and save fails" do
			login_as send(cu)
			post = create_post
			Post.any_instance.stubs(:create_or_update).returns(false)
			deny_changes("Post.find(#{post.id}).updated_at") {
				put :update, :id => post.id, :post => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'edit'
		end

		test "should not update post with #{cu} login and post invalid" do
			login_as send(cu)
			post = create_post
			Post.any_instance.stubs(:valid?).returns(false)
			deny_changes("Post.find(#{post.id}).updated_at") {
				put :update, :id => post.id, :post => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'edit'
		end

		test "should not update post with #{cu} login and invalid id" do
			login_as send(cu)
			put :update, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should destroy post with #{cu} login" do
			login_as send(cu)
			post = create_post
			assert_difference( "User.find(#{post.user_id}).posts_count", -1) {
			assert_difference( "Forum.find(#{post.topic.forum_id}).posts_count", -1) {
			assert_difference( "Topic.find(#{post.topic_id}).posts_count", -1) {
			assert_difference('Post.count', -1) {
				delete :destroy, :id => post.id
			} } } }
			assert_not_nil flash[:notice]
			assert_redirected_to post.topic
		end

		test "should destroy attachments with post destruction and #{cu} login" do
			login_as send(cu)
			post = create_post
			assert_difference( "User.find(#{post.user_id}).posts_count", -1) {
			assert_difference( "Forum.find(#{post.topic.forum_id}).posts_count", -1) {
			assert_difference( "Topic.find(#{post.topic_id}).posts_count", -1) {
#	TODO
#			assert_difference('GroupDocument.count', -1) {
			assert_difference('Post.count', -1) {
				delete :destroy, :id => post.id
			} } } } #}
			assert_not_nil flash[:notice]
			assert_redirected_to post.topic
		end

		test "should not destroy post with #{cu} login and invalid id" do
			login_as send(cu)
			delete :destroy, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	non_site_administrators.each do |cu|

		test "should NOT edit post with #{cu} login" do
			login_as send(cu)
			post = create_post
			get :edit, :id => post.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT update post with #{cu} login" do
			login_as send(cu)
			post = create_post
			deny_changes("Post.find(#{post.id}).updated_at") {
				put :update, :id => post.id, :post => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT destroy post with #{cu} login" do
			login_as send(cu)
			post = create_post
			assert_difference( "User.find(#{post.user_id}).posts_count", 0) {
			assert_difference( "Forum.find(#{post.topic.forum_id}).posts_count", 0) {
			assert_difference( "Topic.find(#{post.topic_id}).posts_count", 0) {
			assert_difference('Post.count', 0) {
				delete :destroy, :id => post.id
			} } } }
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	site_editors.each do |cu|

		test "should get new post with #{cu} login" do
			login_as send(cu)
			topic = create_topic
			get :new, :topic_id => topic.id
			assert_response :success
			assert_template 'new'
		end

		test "should NOT get new post with #{cu} login and invalid topic_id" do
			login_as send(cu)
			get :new, :topic_id => 0
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should create new post with #{cu} login" do
			login_as user = send(cu)
			topic = create_topic
			assert_difference("Forum.find(#{topic.forum.id}).posts_count",1) {
			assert_difference("Topic.find(#{topic.id}).posts_count",1) {
			assert_difference("User.find(#{user.id}).posts_count",1) {
			assert_difference('Post.count',1) {
			assert_difference('GroupDocument.count',0) {
				post :create, :topic_id => topic.id, :post => factory_attributes
			} } } } }
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_not_nil flash[:notice]
			assert_redirected_to topic_path(topic)
		end

		test "should create new post with document and #{cu} login" do
			login_as user = send(cu)
			topic = create_topic
			assert_difference("Forum.find(#{topic.forum.id}).posts_count",1) {
			assert_difference("Topic.find(#{topic.id}).posts_count",1) {
			assert_difference("User.find(#{user.id}).posts_count",1) {
			assert_difference('Post.count',1) {
			assert_difference('GroupDocument.count',1) {
				post :create, :topic_id => topic.id, :post => factory_attributes(
					:group_documents_attributes => [
						group_doc_attributes_with_attachment
					])
			} } } } }
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_equal assigns(:post).user,  user
			assert !assigns(:post).group_documents.empty?
			assigns(:post).group_documents.each do |gd|
				assert_equal gd.user, user
				assert_nil   gd.group
			end	
			assert_not_nil flash[:notice]
			assert_redirected_to topic_path(topic)
			remove_object_with_group_documents(assigns(:post))
		end

		test "should NOT create new post with #{cu} login and invalid topic_id" do
			login_as user = send(cu)
			assert_difference('Post.count',0) {
				post :create, :topic_id => 0, :post => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path
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

	non_site_editors.each do |cu|

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
	group_moderators.each do |cu|

		test "should edit group post with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			post = create_post(:topic => topic)
			get :edit, :id => post.id
			assert_response :success
			assert_template 'edit'
		end

		test "should update group post with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			post = create_post(:topic => topic)
			sleep 1
			assert_changes("Post.find(#{post.id}).updated_at") {
				put :update, :id => post.id, :post => factory_attributes
			}
			assert_not_nil flash[:notice]
			assert_redirected_to post.topic
		end

		test "should not update group post with #{cu} login and save fails" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			post = create_post(:topic => topic)
			Post.any_instance.stubs(:create_or_update).returns(false)
			deny_changes("Post.find(#{post.id}).updated_at") {
				put :update, :id => post.id, :post => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'edit'
		end

		test "should not update group post with #{cu} login and post invalid" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			post = create_post(:topic => topic)
			Post.any_instance.stubs(:valid?).returns(false)
			deny_changes("Post.find(#{post.id}).updated_at") {
				put :update, :id => post.id, :post => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'edit'
		end

		test "should destroy group post with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			post = create_post(:topic => topic)
			assert_difference( "User.find(#{post.user_id}).posts_count", -1) {
			assert_difference( "Forum.find(#{post.topic.forum_id}).posts_count", -1) {
			assert_difference( "Topic.find(#{post.topic_id}).posts_count", -1) {
			assert_difference('Post.count', -1) {
				delete :destroy, :id => post.id
			} } } }
			assert_not_nil flash[:notice]
			assert_redirected_to post.topic
		end

		test "should destroy attachments with group post destruction and #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			post = create_post(:topic => topic)
			assert_difference( "User.find(#{post.user_id}).posts_count", -1) {
			assert_difference( "Forum.find(#{post.topic.forum_id}).posts_count", -1) {
			assert_difference( "Topic.find(#{post.topic_id}).posts_count", -1) {
#	TODO
#			assert_difference('GroupDocument.count', -1) {
			assert_difference('Post.count', -1) {
				delete :destroy, :id => post.id
			} } } } #}
			assert_not_nil flash[:notice]
			assert_redirected_to post.topic
		end

	end

	non_group_moderators.each do |cu|

		test "should NOT edit group post with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			post = create_post(:topic => topic)
			get :edit, :id => post.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT update group post with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			post = create_post(:topic => topic)
			deny_changes("Post.find(#{post.id}).updated_at") {
				put :update, :id => post.id, :post => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT destroy group post with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			post = create_post(:topic => topic)
			assert_difference( "User.find(#{post.user_id}).posts_count", 0) {
			assert_difference( "Forum.find(#{post.topic.forum.id}).posts_count", 0) {
			assert_difference( "Topic.find(#{post.topic.id}).posts_count", 0) {
			assert_difference('Post.count', 0) {
				delete :destroy, :id => post.id
			} } } }
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	group_editors.each do |cu|

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
			assert_difference('GroupDocument.count',0) {
				post :create, :topic_id => topic.id, :post => factory_attributes
			} } } } }
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_not_nil flash[:notice]
			assert_redirected_to topic_path(topic)
		end

		test "should create new group post with document and #{cu} login" do
			login_as user = send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			assert_difference("Forum.find(#{forum.id}).posts_count",1) {
			assert_difference("Topic.find(#{topic.id}).posts_count",1) {
			assert_difference("User.find(#{user.id}).posts_count",1) {
			assert_difference('Post.count',1) {
			assert_difference('GroupDocument.count',1) {
				post :create, :topic_id => topic.id, :post => factory_attributes(
					:group_documents_attributes => [
						group_doc_attributes_with_attachment
					])
			} } } } }
			assert assigns(:forum)
			assert assigns(:topic)
			assert assigns(:post)
			assert_equal assigns(:post).user,  user
			assert !assigns(:post).group_documents.empty?
			assigns(:post).group_documents.each do |gd|
				assert_equal gd.user,  user
				assert_equal gd.group, @membership.group
			end
			assert_not_nil flash[:notice]
			assert_redirected_to topic_path(topic)
			remove_object_with_group_documents(assigns(:post))
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

	non_group_editors.each do |cu|

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

	add_strong_parameters_tests( :post, [ :body ])

protected

	def create_group_forum(group)
		forum = FactoryGirl.create(:forum, :group => group)
		assert_not_nil forum.id
		assert_not_nil forum.group
		forum
	end

	def create_forum_topic(forum)
		topic = FactoryGirl.create(:topic, :forum => forum)
		assert_not_nil topic.id 
		assert_not_nil topic.forum
		assert_not_nil topic.user
		topic
	end

	def create_forum_topic_post(topic)
		post = FactoryGirl.create(:post, :topic => topic)
		assert_not_nil post.id 
		assert_not_nil post.topic
		assert_not_nil post.user
		post
	end

end
