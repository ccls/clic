require 'test_helper'

class GroupRoleTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require(:name)
	assert_should_require_unique(:name)
	assert_should_have_many(:memberships)
#	assert_should_have_many(:users,  :through => :memberships)
#	assert_should_have_many(:groups, :through => :memberships)

end
