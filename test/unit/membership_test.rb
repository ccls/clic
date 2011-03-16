require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_initially_belong_to(:user)
	assert_should_initially_belong_to(:group)
#	assert_should_initially_belong_to(:group_role)
	assert_should_belong_to(:group_role)

	assert_should_protect( :group_id )
	assert_should_protect( :user_id )
	assert_should_protect( :group_role_id )
	assert_should_protect( :approved )

end
