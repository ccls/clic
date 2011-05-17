require 'test_helper'

class MembersOnliesControllerTest < ActionController::TestCase

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login(:show, { 
		:logins => all_test_roles })

	assert_no_access_without_login :show

	assert_access_with_https   :show
	assert_no_access_with_http :show

end
