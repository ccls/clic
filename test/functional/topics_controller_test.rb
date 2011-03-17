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
		Factory.attributes_for(:topic,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin,:editor,:interviewer,:reader,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	setup :create_a_membership

#
#	NO Group Forum Topic
#

	%w( super_user admin editor ).each do |cu|

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
#			assert_difference("Forum.find(#{forum.id}).posts_count",1) {		#	not yet
			assert_difference("Forum.find(#{forum.id}).topics_count",1) {
			assert_difference("User.find(#{user.id}).topics_count",1) {
			assert_difference('Topic.count',1) {
				post :create, :forum_id => forum.id, :topic => factory_attributes.merge(
					:posts_attributes => { "0"=> Factory.attributes_for(:post) })
			} } }
			assert assigns(:topic)
			assert_not_nil flash[:notice]
			assert_redirected_to forum_path(forum)
		end

		test "should NOT create new topic with #{cu} login and invalid forum_id" do
			login_as user = send(cu)
			assert_difference('Topic.count',0) {
				post :create, :forum_id => 0, :topic => factory_attributes.merge(
					:posts_attributes => { "0"=> Factory.attributes_for(:post) })
			}
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT create new topic with #{cu} login when create fails" do
			login_as send(cu)
			forum = create_forum
			Topic.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Topic.count',0) do
				post :create, :forum_id => forum.id, :topic => factory_attributes.merge(
					:posts_attributes => { "0"=> Factory.attributes_for(:post) })
			end
			assert assigns(:topic)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new topic with #{cu} login and invalid topic" do
			login_as send(cu)
			forum = create_forum
			Topic.any_instance.stubs(:valid?).returns(false)
			assert_difference('Topic.count',0) do
				post :create, :forum_id => forum.id, :topic => factory_attributes.merge(
					:posts_attributes => { "0"=> Factory.attributes_for(:post) })
			end
			assert assigns(:topic)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

	end

	%w( reader active_user group_roleless group_reader
			group_administrator group_moderator group_editor 
			nonmember_administrator nonmember_moderator nonmember_editor
			nonmember_reader nonmember_roleless ).each do |cu|

		test "should NOT get new topic with #{cu} login" do
			login_as send(cu)
			forum = create_forum
			get :new, :forum_id => forum.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT create new topic with #{cu} login" do
			login_as send(cu)
			forum = create_forum
			assert_difference('Topic.count',0) do
				post :create, :forum_id => forum.id, :topic => factory_attributes.merge(
					:posts_attributes => { "0"=> Factory.attributes_for(:post) })
			end
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

#
#		Show (any logged in user can view)
#

	%w( super_user admin editor reader active_user 
			group_administrator group_moderator
			group_editor group_reader group_roleless 
			nonmember_administrator nonmember_moderator nonmember_editor
			nonmember_reader nonmember_roleless ).each do |cu|

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

#
#	Group Forum Topic
#

	%w( super_user admin group_administrator group_moderator
			group_editor ).each do |cu|

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
#			assert_difference("Forum.find(#{forum.id}).posts_count",1) {		#	not yet
			assert_difference("Forum.find(#{forum.id}).topics_count",1) {
			assert_difference("User.find(#{user.id}).topics_count",1) {
			assert_difference('Topic.count',1) {
				post :create, :forum_id => forum.id, :topic => factory_attributes.merge(
					:posts_attributes => { "0"=> Factory.attributes_for(:post) })
			} } }
			assert assigns(:topic)
			assert_not_nil flash[:notice]
			assert_redirected_to forum_path(forum)
		end

		test "should NOT create new group topic with #{cu} login when create fails" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			Topic.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Topic.count',0) do
				post :create, :forum_id => forum.id, :topic => factory_attributes.merge(
					:posts_attributes => { "0"=> Factory.attributes_for(:post) })
			end
			assert assigns(:topic)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new group topic with #{cu} login and invalid topic" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			Topic.any_instance.stubs(:valid?).returns(false)
			assert_difference('Topic.count',0) do
				post :create, :forum_id => forum.id, :topic => factory_attributes.merge(
					:posts_attributes => { "0"=> Factory.attributes_for(:post) })
			end
			assert assigns(:topic)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

	end

	%w( editor reader active_user group_roleless group_reader
			nonmember_administrator nonmember_moderator nonmember_editor
			nonmember_reader nonmember_roleless ).each do |cu|

		test "should NOT get new group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			get :new, :forum_id => forum.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT create new group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			assert_difference('Topic.count',0) do
				post :create, :forum_id => forum.id, :topic => factory_attributes.merge(
					:posts_attributes => { "0"=> Factory.attributes_for(:post) })
			end
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

#
#		Show
#

	%w( super_user admin group_administrator group_moderator
			group_editor group_reader ).each do |cu|

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

	%w( editor reader active_user group_roleless
			nonmember_administrator nonmember_moderator nonmember_editor
			nonmember_reader nonmember_roleless ).each do |cu|

		test "should NOT show group topic with #{cu} login" do
			login_as send(cu)
			forum = create_group_forum(@membership.group)
			topic = create_forum_topic(forum)
			get :show, :id => topic.id
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

end
