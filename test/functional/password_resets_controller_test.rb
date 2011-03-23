require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase

	#	I forgot my password presents email field

	test "should get new password reset without login" do
		get :new
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get new password reset with login" do
		login_as active_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end


	#	email submission to send password reset email

	test "should create password reset with valid email" do
		user = active_user
		assert_not_logged_in
		assert_changes("User.find(#{user.id}).perishable_token") {
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			post :create, :email => user.email
		} }
		assert_redirected_to root_path
		assert_not_nil flash[:notice]
		assert_equal user, assigns(:user)
	end

	test "should NOT create password reset with invalid email" do
		assert_not_logged_in
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			post :create, :email => "somerandominvalidemail@email.com"
		}
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create password reset with login" do
		login_as active_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			post :create, :email => 'someunimportantstring@email.com'
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end


	#	perishable_token sent to password reset presents edit password

	test "should edit password reset with valid perishable token" do
		user = active_user
		assert_not_logged_in
		get :edit, :id => user.perishable_token
		assert_response :success
		assert_template 'edit'
		assert_equal user, assigns(:user)
	end

	test "should NOT edit password reset with invalid perishable token" do
		assert_not_logged_in
		get :edit, :id => "someinvaliduserperishable_token"
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT edit password reset with login" do
		login_as active_user
		get :edit, :id => "sometokenthatwontbecheckedanyway"
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end


	#	how to convey valid user when sending new password?
	#	use perishable token as :id
	#	be sure to test that failed attempt doesn't change user's perishable token
	test "should update password with valid perishable token" do
		user = active_user
		assert_changes("User.find(#{user.id}).crypted_password") {
		assert_changes("User.find(#{user.id}).perishable_token") {
			put :update, :id => user.perishable_token,
				:user => { 
					:password => 'alphaV@1!d', 
					:password_confirmation => 'alphaV@1!d' }
		} }
		assert_redirected_to login_path
		assert_not_nil flash[:notice]
		assert_not_logged_in
	end

	test "should NOT update password with invalid perishable token" do
		put :update, :id => "nonexistantuserperishable_token",
			:user => { 
				:password => 'alphaV@1!d', 
				:password_confirmation => 'alphaV@1!d' }
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT update password with login" do
		login_as active_user
		put :update, :id => "sometokenthatwontbecheckedanyway",
			:user => { }
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT update when create_or_update fails" do
		user = active_user
		User.any_instance.stubs(:create_or_update).returns(false)
		deny_changes("User.find(#{user.id}).perishable_token") {
			put :update, :id => user.perishable_token,
				:user => { 
					:password => 'alphaV@1!d', 
					:password_confirmation => 'alphaV@1!d' }
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
		assert_not_logged_in
	end

	test "should NOT update with invalid user" do
		user = active_user
		User.any_instance.stubs(:valid?).returns(false)
		deny_changes("User.find(#{user.id}).perishable_token") {
			put :update, :id => user.perishable_token,
				:user => { 
					:password => 'alphaV@1!d', 
					:password_confirmation => 'alphaV@1!d' }
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
		assert_not_logged_in
	end

	test "should NOT update with invalid password format" do
		user = active_user
		deny_changes("User.find(#{user.id}).perishable_token") {
			put :update, :id => user.perishable_token,
				:user => { 
					:password => 'invalidformat',
					:password_confirmation => 'invalidformat' }
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
		assert_not_logged_in
	end

	test "should NOT update without password" do
		user = active_user
		deny_changes("User.find(#{user.id}).perishable_token") {
			put :update, :id => user.perishable_token,
				:user => { 
					:password_confirmation => 'alphaV@1!d' }
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
		assert_not_logged_in
	end

	test "should NOT update without password confirmation" do
		user = active_user
		deny_changes("User.find(#{user.id}).perishable_token") {
			put :update, :id => user.perishable_token,
				:user => { 
					:password => 'alphaV@1!d' }
		}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
		assert_not_logged_in
	end

end
