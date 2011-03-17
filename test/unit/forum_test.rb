require 'test_helper'

class ForumTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:name)
	assert_should_require_unique(:name, :scope => :group_id)
	assert_should_belong_to(:group)
	assert_should_have_many(:topics)

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

	test "should return only those not associated to a group" do
		create_object(:group => Factory(:group))
		create_object(:group => nil)
		assert Forum.groupless.length > 0
		Forum.groupless.each do |groupless|
			assert_nil groupless.group_id
		end
	end

end
