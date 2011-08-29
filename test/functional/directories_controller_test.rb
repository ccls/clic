require 'test_helper'

class DirectoriesControllerTest < ActionController::TestCase

	approved_users.each do |cu|

		test "should get member directory with #{cu} login" do
			login_as send(cu)
			get :show
			assert_response :success
			assert_template 'show'
		end

	end

	unapproved_users.each do |cu|

		test "should not get member directory with #{cu} login" do
			login_as send(cu)
			get :show
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	test "should not get member directory without login" do
		get :show
		assert_redirected_to_login
	end

end
