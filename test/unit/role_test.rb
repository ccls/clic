require 'test_helper'

class RoleTest < ActiveSupport::TestCase

#	assert_should_act_as_list(:model => 'Role')
#	assert_should_require(:name,
#		:model => 'Role')
#	assert_should_require_unique(:name,
#		:model => 'Role')
#	assert_should_habtm(:users,
#		:model => 'Role')

	assert_should_act_as_list
	assert_should_require(:name)
	assert_should_require_unique(:name)
	assert_should_habtm(:users)

	test "should create role" do
		assert_difference('Role.count',1) do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end 
	end

#protected
#
#	def create_object(options = {})
#		record = FactoryGirl.build(:role,options)
#		record.save
#		record
#	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_role

end
