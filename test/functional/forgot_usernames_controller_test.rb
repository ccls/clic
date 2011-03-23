require 'test_helper'

class ForgotUsernamesControllerTest < ActionController::TestCase

	#	I forgot my username presents email field

	test "should get new forgot username without login" do
		get :new
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get forgot username reset with login" do
		login_as active_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end


	#	email submission to send password reset email

	test "should create forgot username with valid email" do
		user = active_user
		assert_not_logged_in
		post :create, :email => user.email
		assert_response :success
		assert_template 'create'
		assert_not_nil flash[:notice]
		assert_equal user, assigns(:user)
	end

	test "should NOT create forgot username with invalid email" do
		assert_not_logged_in
		post :create, :email => "somerandominvalidemail@email.com"
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create forgot username with login" do
		login_as active_user
		post :create, :email => 'someunimportantstring@email.com'
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end
