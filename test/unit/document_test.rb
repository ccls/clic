require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_require_attribute_length(:title, :in => 4..250)
	assert_should_belong_to(:owner,:class_name => 'User')

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

end
