require 'test_helper'

class EmailConfirmationsControllerTest < ActionController::TestCase

	test "should NOT confirm email without perishable_token" do
		get :confirm
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

	test "should NOT confirm email without valid perishable_token" do
		get :confirm, :id => "some random invalid perishable_token"
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

	test "should NOT confirm email with valid perishable_token and login" do
		u = active_user
		login_as u
		get :confirm, :id => u.perishable_token
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should confirm email with valid perishable_token and no login" do
		u = active_user
		get :confirm, :id => u.perishable_token
		assert_not_nil flash[:notice]
		assert_redirected_to login_path
	end

	test "should NOT resend confirm email without perishable_token" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :resend
		}
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

	test "should NOT resend confirm email without valid perishable_token" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :resend, :id => "some random invalid perishable_token"
		}
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

	test "should NOT resend confirm email with valid perishable_token and login" do
		u = active_user
		login_as u
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :resend, :id => u.perishable_token
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should resend confirm email with valid perishable_token and no login" do
		u = active_user
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			get :resend, :id => u.perishable_token
		}
		assert_not_nil flash[:notice]
		assert_redirected_to login_path
	end

end