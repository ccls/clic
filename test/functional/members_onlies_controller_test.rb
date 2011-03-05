require 'test_helper'

class MembersOnliesControllerTest < ActionController::TestCase

	assert_access_with_login       :show, { 
		:logins => [:superuser,:admin,:editor,:interviewer,:reader,:active_user] }
	assert_no_access_without_login :show

	assert_access_with_https   :show
	assert_no_access_with_http :show

end
