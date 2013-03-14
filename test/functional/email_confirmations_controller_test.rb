require 'test_helper'

class EmailConfirmationsControllerTest < ActionController::TestCase

	assert_no_route :get, :confirm
	assert_no_route :get, :resend

#	test "should NOT confirm email without perishable_token" do
#		assert_raises
#		get :confirm
#		assert_not_nil flash[:error]
#		assert_redirected_to_login
#	end

	test "should NOT confirm email without valid perishable_token" do
		get :confirm, :id => "some random invalid perishable_token"
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

	test "should NOT confirm email with valid perishable_token and login" do
		u = unapproved_user
		login_as u
		get :confirm, :id => u.perishable_token
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should confirm email with valid perishable_token and no login" do
		u = unapproved_user
		get :confirm, :id => u.perishable_token
		assert_not_nil assigns(:user)
		assert_not_nil flash[:notice]
		assert_redirected_to login_path
	end

	test "should NOT confirm email with valid expired perishable_token and no login" do
		remember = User.perishable_token_valid_for
		User.perishable_token_valid_for = 1.second	#	default is 10 minutes
		u = unapproved_user
		sleep 2
		get :confirm, :id => u.perishable_token
		assert_nil assigns(:user)
		assert_nil flash[:notice]
		assert_not_nil flash[:error]
		assert_redirected_to login_path
		User.perishable_token_valid_for = remember
	end

#	test "should NOT resend confirm email without perishable_token" do
#		assert_difference('ActionMailer::Base.deliveries.length',0) {
#			get :resend
#		}
#		assert_not_nil flash[:error]
#		assert_redirected_to_login
#	end

	test "should NOT resend confirm email without valid perishable_token" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :resend, :id => "some random invalid perishable_token"
		}
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

	test "should NOT resend confirm email with valid perishable_token and login" do
		u = unapproved_user
		login_as u
		deny_changes("User.find(#{u.id}).perishable_token") {
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :resend, :id => u.perishable_token
		} }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should resend confirm email with valid expired perishable_token and no login" do
		remember = User.perishable_token_valid_for
		User.perishable_token_valid_for = 1.second  # default is 10 minutes
		u = unapproved_user
		sleep 2
		assert_changes("User.find(#{u.id}).perishable_token") {
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			get :resend, :id => u.perishable_token
		} }
		assert_not_nil flash[:notice]
		assert_redirected_to login_path
		User.perishable_token_valid_for = remember
	end

	test "should resend confirm email with valid perishable_token and no login" do
		u = unapproved_user
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			get :resend, :id => u.perishable_token
		}
		assert_not_nil flash[:notice]
		assert_redirected_to login_path
	end

end
