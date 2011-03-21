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

	setup :create_a_membership

	assert_access_with_login({ 
		:logins => [:superuser,:admin,:editor,:interviewer,:reader,:active_user,
			:unapproved_group_administrator, :group_administrator,
			:group_moderator, :group_editor, :group_reader, :group_roleless,
			:unapproved_nonmember_administrator, :nonmember_administrator,
			:nonmember_editor, :nonmember_reader, :nonmember_roleless ] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	%w( super_user admin group_administrator group_moderator
			group_editor group_reader ).each do |cu|

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

	%w( editor reader active_user group_roleless
			unapproved_group_administrator unapproved_nonmember_administrator
			nonmember_administrator nonmember_moderator nonmember_editor
			nonmember_reader nonmember_roleless ).each do |cu|

		test "should NOT show group forum with #{cu} login" do
			login_as send(cu)
			forum = Factory(:forum, :group => @membership.group)
			assert_not_nil forum.group
			get :show, :id => forum.id
			assert_redirected_to root_path
		end

	end

end
