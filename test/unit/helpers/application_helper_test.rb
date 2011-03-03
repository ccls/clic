require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

	#	No idea why I have to redefine these here,
	#	but without them logged_in? isn't found.
	
#	def logged_in?
#		!current_user.nil?
#	end
#
#	def current_user
#		@current_user ||= if( session && session[:calnetuid] )
#				#	if the user model hasn't been loaded yet
#				#	this will return nil and fail.
#				$CalnetAuthenticatedUser.find_create_and_update_by_uid(session[:calnetuid])
#			else
#				nil
#			end
#	end
	
	def setup
		@controller = TestController.new
		@request  = @controller.request
	end

	test "should respond_to application_root_menu" do
		assert respond_to?(:application_root_menu)
	end
	
#	test "should respond_to application_user_menu" do
#		assert respond_to?(:application_user_menu)
#	end


#	moved this all into users controller test
	
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
