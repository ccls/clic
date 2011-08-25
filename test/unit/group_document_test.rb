require 'test_helper'

class GroupDocumentTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_not_require(:description)
	assert_should_initially_belong_to( :user )	#, :post )
	assert_should_belong_to( :group )
	assert_should_require_attribute_length( :title,       :maximum => 250 )
	assert_should_require_attribute_length( :description, :maximum => 65000 )
	assert_should_protect(:group_id, :user_id)

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

	test "should create with attachment" do
		pending
	end

end
