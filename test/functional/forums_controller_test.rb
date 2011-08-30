require 'test_helper'

class ForumsControllerTest < ActionController::TestCase

	assert_no_route(:get, :index)
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Forum',
		:actions => [:new,:create,:show],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_forum
	}
	def factory_attributes(options={})
		Factory.attributes_for(:forum,options)
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	with_options :actions => [:new,:create] do |o|
		o.assert_access_with_login({    :logins => site_editors })
		o.assert_no_access_with_login({ :logins => non_site_editors,
			:redirect => :members_only_path })
	end

	with_options :actions => [:show] do |o|
		o.assert_access_with_login({    :logins => approved_users  })
		o.assert_no_access_with_login({ :logins => unapproved_users })
	end

	assert_no_access_without_login
	assert_access_with_https
	assert_no_access_with_http

	group_readers.each do |cu|

		test "should NOT show group forum with #{cu} login and invalid id" do
			login_as send(cu)
			forum = Factory(:forum, :group => @membership.group)
			assert_not_nil forum.id
			assert_not_nil forum.group
			get :show, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should show group forum with #{cu} login" do
			login_as send(cu)
			forum = Factory(:forum, :group => @membership.group)
			assert_not_nil forum.id
			assert_not_nil forum.group
			get :show, :id => forum.id
			assert_response :success
			assert_template 'show'
		end

	end

	non_group_readers.each do |cu|

		test "should NOT show group forum with #{cu} login" do
			login_as send(cu)
			forum = Factory(:forum, :group => @membership.group)
			assert_not_nil forum.group
			get :show, :id => forum.id
			assert_redirected_to root_path
		end

	end

	site_editors.each do |cu|

		test "should NOT create forum without group with #{cu} login " <<
				"with invalid forum" do
			login_as send(cu)
			Forum.any_instance.stubs(:valid?).returns(false)
			assert_difference('Forum.count',0) {
				post :create, :forum => Factory.attributes_for(:forum)
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create forum without group with #{cu} login " <<
				"when forum save fails" do
			login_as send(cu)
			Forum.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Forum.count',0) {
				post :create, :forum => Factory.attributes_for(:forum)
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

	end

##################################################

	group_editors.each do |cu|

		test "should get new forum with group and #{cu} login" do
			login_as send(cu)
			get :new, :group_id => @membership.group.id
			assert_response :success
			assert_template 'new'
			assert assigns(:forum)
		end

		test "should create forum with group and #{cu} login" do
			login_as send(cu)
			assert_difference('Forum.count',1) {
				post :create, :group_id => @membership.group.id,
					:forum => Factory.attributes_for(:forum)
			}
			assert_not_nil assigns(:forum).group
			assert_equal @membership.group, assigns(:forum).group
			assert_redirected_to assigns(:forum)
			assert_not_nil flash[:notice]
		end

		test "should NOT create forum with group and #{cu} login " <<
				"with invalid forum" do
			login_as send(cu)
			Forum.any_instance.stubs(:valid?).returns(false)
			assert_difference('Forum.count',0) {
				post :create, :group_id => @membership.group.id,
					:forum => Factory.attributes_for(:forum)
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create forum with group and #{cu} login " <<
				"when forum save fails" do
			login_as send(cu)
			Forum.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Forum.count',0) {
				post :create, :group_id => @membership.group.id,
					:forum => Factory.attributes_for(:forum)
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

	end

	non_group_editors.each do |cu|

		test "should NOT get new forum with group and #{cu} login" do
			login_as send(cu)
			get :new, :group_id => @membership.group.id
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

		test "should NOT create forum with group and #{cu} login" do
			login_as send(cu)
			assert_difference('Forum.count',0) {
				post :create, :group_id => @membership.group.id,
					:forum => Factory.attributes_for(:forum)
			}
			assert_not_nil flash[:error]
			assert_redirected_to members_only_path
		end

	end

end
