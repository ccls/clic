require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

	def self.calendar_readers
		@calendar_readers ||= %w( superuser admin editor interviewer reader )
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login(    :show, { 
		:logins => calendar_readers })

	assert_no_access_with_login( :show, { 
		:logins => ( ALL_TEST_ROLES - calendar_readers ) })

	assert_no_access_without_login :show

	assert_access_with_https   :show
	assert_no_access_with_http :show

end
