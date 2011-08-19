require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = { :actions => [:show] }

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login(   { :logins => site_readers })
	assert_no_access_with_login({ :logins => non_site_readers })
	assert_no_access_without_login
	assert_access_with_https
	assert_no_access_with_http

end
