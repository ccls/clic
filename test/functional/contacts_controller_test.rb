require 'test_helper'

class ContactsControllerTest < ActionController::TestCase

	setup :create_a_membership

	approved_users.each do |cu|

		test "should get study contact info with #{cu} login" do
			login_as send(cu)
			get :index
			assert_response :success
			assert_template 'index'
		end

	end

	unapproved_users.each do |cu|

		test "should NOT get study contact info with #{cu} login" do
			login_as send(cu)
			get :index
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	test "should NOT get study contact info without login" do
		get :index
		assert_redirected_to_login
	end

end
