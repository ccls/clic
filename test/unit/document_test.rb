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

	test "should create with attachment" do
		assert_difference('Document.count',1) {
			@object = create_object(
				:document => File.open(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf')
			)
		}
		@object.destroy
	end

end
