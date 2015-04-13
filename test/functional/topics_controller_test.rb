require 'test_helper'

class TopicsControllerTest < ActionController::TestCase

	#	no forum_id
	assert_no_route(:get,:index)
	assert_no_route(:get,:new)
	assert_no_route(:post,:create)

	#	no id
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Topic',
		:actions => [:show],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_topic
	}
	def factory_attributes(options={})
		FactoryGirl.attributes_for(:topic,options)
	end

	assert_access_with_login({    :logins => approved_users })
	assert_no_access_with_login({ :logins => unapproved_users })

	with_options :actions => [:edit,:update] do |o|
		o.assert_access_with_login({    :logins => site_editors })
		o.assert_no_access_with_login({ :logins => non_site_editors,
			:no_redirect_check => true })	#	goes back to forum path
	end

	with_options :actions => [:destroy] do |o|
		o.assert_access_with_login({    :logins => site_administrators,
			:no_redirect_check => true })	#	goes back to forum and not topic index
		o.assert_no_access_with_login({ :logins => non_site_administrators })
	end

	assert_no_access_without_login

	# a @membership is required so that those group roles will work
	setup :create_a_membership

#
#	NO Group Forum Topic
#

	site_editors.each do |cu|

		test "should get new topic with #{cu} login" do
			login_as send(cu)
			forum = create_forum
			get :new, :forum_id => forum.id
			assert_response :success
			assert_template 'new'
		end

		test "should NOT get new topic with #{cu} login and invalid forum_id" do
			login_as send(cu)
			get :new, :forum_id => 0
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should create new topic with #{cu} login" do
			login_as user = send(cu)
			forum = create_forum
			assert_difference("Forum.find(#{forum.id}).posts_count",1) {
			assert_difference("Forum.find(#{forum.id}).topics_count",1) {
			assert_difference("User.find(#{user.id}).topics_count",1) {
			assert_difference('Post.count',1) {
			assert_difference('Topic.count',1) {
			assert_difference('GroupDocument.count',0) {
				post_create(forum.id)
			} } } } } }
			assert assigns(:topic)
			assert_not_nil flash[:notice]
			assert_redirected_to forum_path(forum)
		end

		test "should create new topic with document #{cu} login" do
			login_as user = send(cu)
			forum = create_forum
			assert_difference("Forum.find(#{forum.id}).posts_count",1) {
			assert_difference("Forum.find(#{forum.id}).topics_count",1) {
			assert_difference("User.find(#{user.id}).topics_count",1) {
			assert_difference('Post.count',1) {
			assert_difference('Topic.count',1) {
			assert_difference('GroupDocument.count',1) {
				post :create, :forum_id => forum.id, :topic => factory_attributes(
					:posts_attributes => [FactoryGirl.attributes_for(:post,
						:group_documents_attributes => [
							group_doc_attributes_with_attachment
						])])
			} } } } } }
			assert assigns(:forum)
			assert assigns(:topic)
			assert !assigns(:topic).posts.empty?
			assert !assigns(:topic).posts.first.group_documents.empty?
			assert_not_nil flash[:notice]
			assert_redirected_to forum_path(forum)
			remove_object_with_group_documents(assigns(:topic).posts.first)
		end

		test "should NOT create new topic with #{cu} login and invalid forum_id" do
			login_as user = send(cu)
			assert_difference('Topic.count',0) {
			assert_difference('Post.count',0) {
			assert_difference('GroupDocument.count',0) {
				post_create(0)
			} } } 
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT create new topic with #{cu} login when create fails" do
			login_as send(cu)
			forum = create_forum
			Topic.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Topic.count',0) {
			assert_difference('Post.count',0) {
			assert_difference('GroupDocument.count',0) {
				post_create(forum.id)
			} } }
			assert assigns(:topic)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new topic with #{cu} login and invalid topic" do
			login_as send(cu)
			forum = create_forum
			Topic.any_instance.stubs(:valid?).returns(false)
			assert_difference('Topic.count',0) {
			assert_difference('Post.count',0) {
			assert_difference('GroupDocument.count',0) {
				post_create(forum.id)
			} } }
			assert assigns(:topic)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT update topic with #{cu} login when save fails" do
			login_as send(cu)
			topic = create_topic
			Topic.any_instance.stubs(:create_or_update).returns(false)
			deny_changes("Topic.find(#{topic.id}).updated_at") {
				put :update, :id => topic.id, :topic => factory_attributes
			}
			assert assigns(:topic)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

		test "should NOT update topic with #{cu} login and invalid topic" do
			login_as send(cu)
			topic = create_topic
			Topic.any_instance.stubs(:valid?).returns(false)
			deny_changes("Topic.find(#{topic.id}).updated_at") {
				put :update, :id => topic.id, :topic => factory_attributes
			}
			assert assigns(:topic)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

	end

	non_site_editors.each do |cu|

		test "should NOT get new topic with #{cu} login" do
			login_as send(cu)
			forum = create_forum
			get :new, :forum_id => forum.id
			assert_not_nil flash[:error]
			assert_redirected_to forum_path(forum)
		end

		test "should NOT create new topic with #{cu} login" do
			login_as send(cu)
			forum = create_forum
			assert_difference('Topic.count',0) {
			assert_difference('Post.count',0) {
			assert_difference('GroupDocument.count',0) {
				post_create(forum.id)
			} } }
			assert_not_nil flash[:error]
			assert_redirected_to forum_path(forum)
		end

	end

#
#		Show (any logged in user can view)
#

	approved_users.each do |cu|

		test "should NOT show topic with #{cu} login and invalid id" do
			login_as send(cu)
			forum = create_forum
			topic = create_forum_topic(forum)
			get :show, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should show topic with #{cu} login" do
			login_as send(cu)
			forum = create_forum
			topic = create_forum_topic(forum)
			get :show, :id => topic.id
			assert_response :success
			assert_template 'show'
		end

	end

	unapproved_users.each do |cu|

		test "should NOT show topic with #{cu} login" do
			login_as send(cu)
			forum = create_forum
			topic = create_forum_topic(forum)
			get :show, :id => topic.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

#
#	Group Forum Topic
#

	group_moderators.each do |cu|

		test "should destroy topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			assert_difference("Topic.count",-1) {
				delete :destroy, :id => topic.id
			}
			assert_redirected_to forum_path(forum)
		end

	end

	non_group_moderators.each do |cu|

		test "should not destroy topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			assert_difference("Topic.count",0) {
				delete :destroy, :id => topic.id
			}
			assert_redirected_to root_path
		end

	end

	group_editors.each do |cu|

		test "should get new group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			get :new, :forum_id => forum.id
			assert_response :success
			assert_template 'new'
		end

		test "should create new group topic with #{cu} login" do
			login_as user = send(cu)
			forum = create_group_forum(@membership.group)
			assert_difference("Forum.find(#{forum.id}).posts_count",1) {
			assert_difference("Forum.find(#{forum.id}).topics_count",1) {
			assert_difference("User.find(#{user.id}).topics_count",1) {
			assert_difference('Topic.count',1) {
			assert_difference('Post.count',1) {
			assert_difference('GroupDocument.count',0) {
				post_create(forum.id)
			} } } } } }
			assert assigns(:topic)
			assert_not_nil flash[:notice]
			assert_redirected_to forum_path(forum)
		end

		test "should create new group topic with document and #{cu} login" do
			login_as user = send(cu)
			forum = create_group_forum(@membership.group)
			assert_difference("Forum.find(#{forum.id}).posts_count",1) {
			assert_difference("Forum.find(#{forum.id}).topics_count",1) {
			assert_difference("User.find(#{user.id}).topics_count",1) {
			assert_difference('Topic.count',1) {
			assert_difference('Post.count',1) {
			assert_difference('GroupDocument.count',1) {
				post :create, :forum_id => forum.id, :topic => factory_attributes(
					:posts_attributes => [FactoryGirl.attributes_for(:post,
						:group_documents_attributes => [
							group_doc_attributes_with_attachment
						])])
			} } } } } }
			assert assigns(:forum)
			assert assigns(:topic)
			assert !assigns(:topic).posts.empty?
			assert !assigns(:topic).posts.first.group_documents.empty?
			assert_equal assigns(:topic).posts.first.group_documents.first.group, @membership.group
			assert_not_nil flash[:notice]
			assert_redirected_to forum_path(forum)
			remove_object_with_group_documents(assigns(:topic).posts.first)
		end

		test "should NOT create new group topic with #{cu} login when create fails" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			Topic.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Topic.count',0) {
			assert_difference('Post.count',0) {
			assert_difference('GroupDocument.count',0) {
				post_create(forum.id)
			} } }
			assert assigns(:topic)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new group topic with #{cu} login and invalid topic" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			Topic.any_instance.stubs(:valid?).returns(false)
			assert_difference('Topic.count',0) {
			assert_difference('Post.count',0) {
			assert_difference('GroupDocument.count',0) {
				post_create(forum.id)
			} } }
			assert assigns(:topic)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should edit group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			get :edit, :id => topic.id
			assert_response :success
			assert_template 'edit'
		end

		test "should NOT update group topic with #{cu} login when save fails" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			Topic.any_instance.stubs(:create_or_update).returns(false)
			deny_changes("Topic.find(#{topic.id}).updated_at") {
				put :update, :id => topic.id, :topic => factory_attributes
			}
			assert assigns(:topic)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

		test "should NOT update group topic with #{cu} login and invalid topic" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			Topic.any_instance.stubs(:valid?).returns(false)
			deny_changes("Topic.find(#{topic.id}).updated_at") {
				put :update, :id => topic.id, :topic => factory_attributes
			}
			assert assigns(:topic)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

	end

	non_group_editors.each do |cu|

		test "should NOT get new group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			get :new, :forum_id => forum.id
			assert_not_nil flash[:error]
			assert_redirected_to forum_path(forum)
		end

		test "should NOT create new group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			assert_difference('Topic.count',0) {
			assert_difference('Post.count',0) {
			assert_difference('GroupDocument.count',0) {
				post_create(forum.id)
			} } }
			assert_not_nil flash[:error]
			assert_redirected_to forum_path(forum)
		end

		test "should NOT edit group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			get :edit, :id => topic.id
			assert_not_nil flash[:error]
			assert_redirected_to forum_path(forum)
		end

		test "should NOT update group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			deny_changes("Topic.find(#{topic.id}).updated_at") {
				put :update, :id => topic.id, :topic => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_redirected_to forum_path(forum)
		end

	end

#
#		Show
#

	group_readers.each do |cu|

		test "should NOT show group topic with #{cu} login and invalid id" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			get :show, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should show group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			get :show, :id => topic.id
			assert_response :success
			assert_template 'show'
		end

	end

	non_group_readers.each do |cu|

		test "should NOT show group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			get :show, :id => topic.id
			assert_redirected_to root_path
		end

	end

	add_strong_parameters_tests( :topic, [ :title ])

	%w( posts_attributes ).each do |attr|
		test "params should permit topic:#{attr} subkey as array" do
			@controller.params=HWIA.new(:topic => { attr => ['funky'] })
			assert @controller.send("topic_params").permitted?
		end
	end

	%w( body group_documents_attributes ).each do |attr|
		test "params should permit topic:posts_attributes:#{attr} subkey as array" do
			@controller.params=HWIA.new(:topic => { :posts_attributes => [{ attr => 'funky' }] })
			assert @controller.send("topic_params").permitted?
		end
	end

	%w( title document ).each do |attr|
		test "params should permit topic:posts_attributes:group_documents_attributes:#{attr} subkey" do
			@controller.params=HWIA.new(:topic => { :posts_attributes => 
				[{:group_documents_attributes => { attr => 'funky' }}]})
			assert @controller.send("topic_params").permitted?
		end
	end

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

	def post_create(forum_id)
		post :create, :forum_id => forum_id, :topic => factory_attributes(
			:posts_attributes => [FactoryGirl.attributes_for(:post)])
	end

end
