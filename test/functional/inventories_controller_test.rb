require 'test_helper'

class InventoriesControllerTest < ActionController::TestCase
include TestStartupShutdown
include TestSunspot

	# a @membership is required so that those group roles will work
	setup :create_a_membership

#	TODO THIS WILL HAVE LIMITED ACCESS, BUT UNTIL THEN ...
	assert_access_with_login(:show, { :logins => site_administrators })
	assert_no_access_with_login(:show, { :logins => non_site_administrators })
	assert_no_access_without_login :show
	assert_access_with_https   :show
	assert_no_access_with_http :show

end
