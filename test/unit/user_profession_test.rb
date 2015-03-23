require 'test_helper'

class UserProfessionTest < ActiveSupport::TestCase

#	NOTE As a rich join, this is a bit excessive anyhow
#	Due to the factory setup, this will create 2
#	assert_should_create_default_object
	assert_should_initially_belong_to(:user)
	assert_should_initially_belong_to(:profession)
#	assert_should_protect( :profession_id )
#	assert_should_protect( :user_id )

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_user_profession

end
