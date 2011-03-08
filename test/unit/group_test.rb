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

end
