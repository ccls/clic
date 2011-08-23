require 'test_helper'

class UserProfessionTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:user)
	assert_should_initially_belong_to(:profession)
	assert_should_protect( :profession_id )
	assert_should_protect( :user_id )

end
