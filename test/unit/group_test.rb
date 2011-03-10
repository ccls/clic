require 'test_helper'

class GroupTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list( :scope => :parent_id )
	assert_should_require(:name)
	assert_should_require_unique(:name)
	assert_should_have_many(:forums)
#	assert_should_habtm(:users)
	assert_should_have_many(:memberships)
#	assert_should_have_many(:users, :through => :memberships)
	assert_should_belong_to( :parent, 
		:class_name => 'Group' )
#	assert_should_have_many( :children,
#		:foreign_key => 'parent_id' )
	assert_should_have_many(:announcements)
	assert_should_have_many(:events)

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

	test "should find by name with ['string']" do
		object = Group['Coordination Group']
		assert object.is_a?(Group)
	end

	test "should find by name with [:symbol]" do
		object = Group['Coordination Group'.to_sym]
		assert object.is_a?(Group)
	end

end
