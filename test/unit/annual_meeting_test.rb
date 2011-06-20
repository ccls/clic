require 'test_helper'

class AnnualMeetingTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:meeting, :abstract)
	assert_should_require_attribute_length( :meeting,  :maximum => 250 )
	assert_should_require_attribute_length( :abstract, :maximum => 65000 )
	assert_should_have_many(:group_documents, :as => :attachable)

	test "should return meeting as to_s" do
		object = create_object
		assert_equal object.meeting, "#{object}"
	end

end
