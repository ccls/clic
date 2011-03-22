require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase

	#	I forgot my password presents email field

	test "should get new password reset without login" do
pending
	end

	test "should NOT get new password reset with login" do
pending
	end


	#	email submission to send password reset email

	test "should create password reset with valid email" do
pending
	end

	test "should NOT create password reset with invalid email" do
pending
	end

	test "should NOT create password reset with login" do
pending
	end


	#	perishable_token sent to password reset presents edit password

	test "should show password reset with valid perishable token" do
pending
	end

	test "should NOT show password reset with invalid perishable token" do
pending
	end

	test "should NOT show password reset with login" do
pending
	end


	#	how to convey valid user when sending new password?
	#	hidden field with perishable_token?
	test "should update password with valid perishable token" do
pending
	end

	test "should NOT update password with invalid perishable token" do
pending
	end

	test "should NOT update password with login" do
pending
	end

end
