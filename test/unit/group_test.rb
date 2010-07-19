require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < ActiveSupport::TestCase

	assert_should_require(:name)
	assert_should_require_unique(:name)
	assert_should_have_many(:forums)
	assert_should_habtm(:users)

	test "should create group" do
		assert_difference('Group.count') do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:group,options)
		record.save
		record
	end

end
