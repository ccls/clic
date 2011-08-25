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
#	assert_should_have_many(:announcements)
	assert_should_have_many(:events)
	assert_should_have_many(:documents, :class_name => 'GroupDocument')
	assert_should_require_attribute_length( :name,  :maximum => 250 )

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

	test "should not be allowed to be own parent" do
		object = create_object
		deny_changes("Group.find(#{object.id}).parent_id") {
		deny_changes("Group.find(#{object.id}).groups_count") {
#			object.parent = object	#	skips validations
#			object.update_attribute(:parent_id, object.id)	#	skips validations also
			object.update_attributes(:parent_id => object.id)
#			object.parent_id = object.id
#			object.save
			assert object.errors.on(:parent_id)
		} }
		object.reload
		assert_nil object.parent
		assert object.children.empty?
	end

	test "should not be allowed to be own child" do
		object = create_object
		deny_changes("Group.find(#{object.id}).parent_id") {
		deny_changes("Group.find(#{object.id}).groups_count") {
			object.children << object
			assert object.errors.on(:parent_id)
		} }
		object.reload
		assert_nil object.parent
		assert object.children.empty?
	end

end
