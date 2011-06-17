require 'test_helper'

class GroupRoleTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require(:name)
	assert_should_require_unique(:name)
	assert_should_have_many(:memberships)
#	assert_should_have_many(:users,  :through => :memberships)
#	assert_should_have_many(:groups, :through => :memberships)
	assert_should_require_attribute_length( :name,  :maximum => 250 )

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

	test "should find by name with ['string']" do
		object = GroupRole['moderator']
		assert object.is_a?(GroupRole)
	end

	test "should find by name with [:symbol]" do
		object = GroupRole[:moderator]
		assert object.is_a?(GroupRole)
	end

end
