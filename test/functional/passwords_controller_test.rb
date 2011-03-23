require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase

	test "should edit password with self login" do
		login_as user = active_user
		get :edit
		assert_response :success
		assert_template 'edit'
	end

	test "should update password with self login" do
		login_as user = active_user
		put :update, :user => {
			:password => 'alphaV@1!d', 
			:password_confirmation => 'alphaV@1!d' }
		assert_logged_in
		assert_not_nil flash[:notice]
		assert_redirected_to user_path(user)
	end

	test "should NOT update user without password" do
		login_as active_user
		put :update, :user => { :password => nil, :password_confirmation => 'alphaV@1!d' }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update user without password confirmation" do
		login_as active_user
		put :update, :user => { :password => 'alphaV@1!d', :password_confirmation => nil }
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user without password and password confirmation" do
		login_as user = active_user
		put :update, :user => { :password => nil, :password_confirmation => nil }
		assert_not_nil flash[:warn]
		assert_redirected_to user_path(user)
	end

	test "should NOT update user without complex password" do
		login_as active_user
		put :update, :user => {
			:password              => 'mybigbadpassword',
			:password_confirmation => 'mybigbadpassword' }
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user without matching password and confirmation" do
		login_as active_user
		put :update, :user => {
			:password => 'alphaV@1!d', 
			:password_confirmation => 'betaV@1!d' }
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end



#	%w( editor reader active_user ).each do |cu|
#	
#		test "should NOT edit password with #{cu} login" do
#	pending
#		end
#	
#		test "should NOT update password with #{cu} login" do
#	pending
#		end
#	
#	end

	test "should NOT edit password without login" do
pending
	end

	test "should NOT update password without login" do
pending
	end

end
