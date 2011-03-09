require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

	test "should not log in without email confirmation" do
		assert_not_logged_in
		user = active_user(:email_confirmed_at => nil)
		assert_not_logged_in
		user_session = UserSession.create(user)
		assert user_session.errors.on_attr_and_type(:base, :unconfirmed_email)
		assert_nil UserSession.find
		assert_not_logged_in
	end

	test "should not automatically log user in after creation" do
		assert_not_logged_in
		user = active_user
		assert_not_nil user.email_confirmed_at
		assert_not_logged_in
	end

	test "should get login if NOT logged in" do
		get :new
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get login if logged in" do
		login_as active_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should create session if NOT logged in" do
		user = active_user
		post :create, :user_session => {
			:username => user.username,
			:password => Factory.attributes_for(:user)[:password]
		}
		assert_redirected_to root_path
	end

	test "should redirect to return_to on login" do
		session[:return_to] = "http://www.google.com"
		user = active_user
		post :create, :user_session => {
			:username => user.username,
			:password => Factory.attributes_for(:user)[:password]
		}
		assert_redirected_to "http://www.google.com"
		assert_nil session[:return_to]
	end

	test "should NOT create session if logged in" do
		login_as active_user
		user = active_user
		post :create, :user_session => {
			:username => user.username,
			:password => Factory.attributes_for(:user)[:password]
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create session without username and password" do
		post :create, :user_session => { }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create session without password" do
		user = active_user
		post :create, :user_session => {
			:username => user.username
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create session without username" do
		user = active_user
		post :create, :user_session => {
			:password => Factory.attributes_for(:user)[:password]
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create session with bad username" do
		user = active_user
		post :create, :user_session => {
			:username => 'fake_username',
			:password => Factory.attributes_for(:user)[:password]
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create session with bad password" do
		user = active_user
		post :create, :user_session => {
			:username => user.username,
			:password => 'wrongpassword'
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should increment failed_login_count when login fails" do
		user = active_user
		assert_difference("User.find(#{user.id}).failed_login_count",1){
			post :create, :user_session => {
				:username => user.username,
				:password => 'wrongpassword'
			}
		}
	end

	test "should clear failed_login_count with successful login" do
		user = active_user
		user.update_attribute(:failed_login_count, 5)
		assert_equal 5, user.reload.failed_login_count
		post :create, :user_session => {
			:username => user.username,
			:password => Factory.attributes_for(:user)[:password]
		}
		assert_logged_in
		assert_equal 0, user.reload.failed_login_count
	end

	test "should NOT login with high failed_login_count" do
		user = active_user
		user.update_attribute(:failed_login_count, 50)
		assert_equal 50, user.reload.failed_login_count
		post :create, :user_session => {
			:username => user.username,
			:password => Factory.attributes_for(:user)[:password]
		}
		assert_equal 50, user.reload.failed_login_count
		assert assigns(:user_session).errors.on(:base)
		assert_not_logged_in
	end

	test "should NOT logout if NOT logged in" do
		delete :destroy
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

	test "should logout if logged in" do
		login_as user
		delete :destroy
		assert_not_nil flash[:notice]
		assert_redirected_to root_path
	end

end
