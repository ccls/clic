require 'test_helper'

class ForumsControllerTest < ActionController::TestCase

	assert_no_route(:get,:index)
	assert_no_route(:get,:new)
	assert_no_route(:post,:create)

	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Forum',
		:actions => [:show],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_forum
	}
	def factory_attributes(options={})
		Factory.attributes_for(:forum,options)
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login({ 
		:logins => ( all_test_roles - unapproved_users ) })

	assert_no_access_with_login({ 
		:logins => unapproved_users })

	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	def self.group_readers
		@group_readers ||= %w( 
			superuser administrator group_administrator group_moderator
			group_editor group_reader )
	end

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

	( all_test_roles - group_readers ).each do |cu|

		test "should NOT show group forum with #{cu} login" do
			login_as send(cu)
			forum = Factory(:forum, :group => @membership.group)
			assert_not_nil forum.group
			get :show, :id => forum.id
			assert_redirected_to root_path
		end

	end

end
