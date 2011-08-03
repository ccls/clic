require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

#	def setup
#		@controller = TestController.new
#		@request  = @controller.request
#	end
#
#	test "should respond_to application_root_menu" do
#		assert respond_to?(:application_root_menu)
#	end
#	
#	test "should respond_to application_user_menu" do
#		assert respond_to?(:application_user_menu)
#	end

#	moved this all into users controller test as TestController
#	does not include app specific stuff from ApplicationController
#
#	test "application_user_menu should return nothing without login" do
#		response = application_user_menu
#		assert response.blank?
#	end
#
#	test "application_user_menu should return menu list with admin login" do
#		login_as admin_user
#		assert logged_in?
#		assert current_user.may_edit?
#		response = application_user_menu
#		assert !response.blank?
#		html = HTML::Document.new(response).root
#		assert_select html, 'ul#PrivateNav', 1 do
#			assert_select 'li', 5
#		end
#	end
#
#	test "application_user_menu should return nothing with active_user login" do
#		login_as active_user
#		assert logged_in?
#		assert !current_user.may_edit?
#		response = application_user_menu
#		assert response.blank?
#	end

end

