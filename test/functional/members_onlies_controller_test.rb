require 'test_helper'

class MembersOnliesControllerTest < ActionController::TestCase

	# a @membership is required so that those group roles will work
	setup :create_a_membership

  ASSERT_ACCESS_OPTIONS = { :actions => [:show],
		:skip_show_failure => true }

	assert_access_with_login({ :logins => all_test_roles })
	assert_no_access_without_login

end
