require 'test_helper'

class EventTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_require(:content)
	assert_should_require(:begins_on)
	assert_should_initially_belong_to( :user )
	assert_should_belong_to( :group )
	assert_requires_complete_date( :begins_on )
	assert_should_protect(:group_id)
	assert_should_protect(:user_id)

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

end
