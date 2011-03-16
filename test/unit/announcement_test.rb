require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_require(:content)
	assert_should_initially_belong_to( :user )
	assert_should_belong_to( :group )

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

end
