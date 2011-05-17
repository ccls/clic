require 'test_helper'

class DocFormTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_require(:abstract)

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

end