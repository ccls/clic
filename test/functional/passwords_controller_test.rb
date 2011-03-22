require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase

	%w( super_user admin ).each do |cu|
	
		test "should edit password with #{cu} login" do
	pending
		end
	
		test "should update password with #{cu} login" do
	pending
		end
	
	end

	test "should edit password with self login" do
pending
	end

	test "should update password with self login" do
pending
	end

	%w( editor reader active_user ).each do |cu|
	
		test "should NOT edit password with #{cu} login" do
	pending
		end
	
		test "should NOT update password with #{cu} login" do
	pending
		end
	
	end

	test "should NOT edit password without login" do
pending
	end

	test "should NOT update password without login" do
pending
	end

end
