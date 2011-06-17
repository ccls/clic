require 'test_helper'

class DocFormTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title, :abstract)

	assert_should_require_attribute_length( :title,    :maximum => 250 )
	assert_should_require_attribute_length( :abstract, :maximum => 65000 )

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

end
