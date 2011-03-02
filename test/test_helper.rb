ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase

	fixtures :all

	def login_as( user=nil )
		user_id = ( user.is_a?(User) ) ? user.id : user
		if !user_id.blank?
			@request.session[:user_id] = user_id
			UserSession.create(User.find(user_id))
#			stub_ucb_ldap_person()
#			User.find_create_and_update_by_uid(uid)
		end
	end
	alias :login :login_as
	alias :log_in :login_as

	def assert_redirected_to_login
		assert_response :redirect
#		assert_match "https://auth-test.berkeley.edu/cas/login",
#			@response.redirected_to
	end

	def assert_redirected_to_logout
		assert_response :redirect
#		assert_match "https://auth-test.berkeley.edu/cas/logout",
#			@response.redirected_to
	end

	def assert_logged_in
		assert_not_nil session[:user_id]
		assert_not_nil UserSession.find
	end

	def assert_not_logged_in
		assert_nil session[:user_id]
		assert_nil UserSession.find
	end

end

class ActionController::TestCase
	setup :turn_https_on
	require 'authlogic/test_case'
#	include Authlogic::TestCase
	setup :activate_authlogic
end

