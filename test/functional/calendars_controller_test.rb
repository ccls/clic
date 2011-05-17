require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login(    :show, { 
		:logins => site_readers })

	assert_no_access_with_login( :show, { 
		:logins => non_site_readers })

	assert_no_access_without_login :show

	assert_access_with_https   :show
	assert_no_access_with_http :show

end
