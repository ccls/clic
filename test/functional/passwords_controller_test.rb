require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase

	test "should edit password with self login" do
		login_as user = unapproved_user
		get :edit
		assert_response :success
		assert_template 'edit'
	end

	test "should update password with self login" do
		login_as user = unapproved_user
		put :update, :user => password_attributes
		assert_logged_in
		assert_not_nil flash[:notice]
		assert_redirected_to user_path(user)
	end

	test "should NOT update user without current password" do
		login_as unapproved_user
		put :update, :user => password_attributes(:current_password => nil)
		assert_not_nil flash[:error]
		assert_redirected_to edit_password_path
	end

	test "should NOT update user without valid current password" do
		login_as unapproved_user
		put :update, :user => password_attributes(:current_password => 'iforgot')
		assert_not_nil flash[:error]
		assert_redirected_to edit_password_path
	end

	test "should NOT update user without password" do
		login_as unapproved_user
		put :update, :user => password_attributes(:password => nil)
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update user without password confirmation" do
		login_as unapproved_user
		put :update, :user => password_attributes(:password_confirmation => nil)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user without password and password confirmation" do
		login_as user = unapproved_user
		put :update, :user => password_attributes(
			:password => nil, 
			:password_confirmation => nil )
		assert_not_nil flash[:warn]
		assert_redirected_to user_path(user)
	end

	test "should NOT update user without complex password" do
		login_as unapproved_user
		put :update, :user => password_attributes(
			:password              => 'mybigbadpassword',
			:password_confirmation => 'mybigbadpassword' )
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user without matching password and confirmation" do
		login_as unapproved_user
		put :update, :user => password_attributes(
			:password_confirmation => 'betaV@1!d' )
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT edit password without login" do
		get :edit
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

	test "should NOT update password without login" do
		put :update, :user => password_attributes
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

protected

	def password_attributes(options={})
		{	:current_password => 'V@1!dP@55w0rd',
			:password => 'alphaV@1!d', 
			:password_confirmation => 'alphaV@1!d' 
		}.merge(options)
	end

end
