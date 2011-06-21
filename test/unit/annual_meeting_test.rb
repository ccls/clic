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

	test "should create annual_meeting with nested attributes for group_documents" do
		user = Factory(:user)
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',1) {
		assert_difference('AnnualMeeting.count',1) {
			object = Factory(:annual_meeting,
				:current_user => user,
				:group_documents_attributes => [
					Factory.attributes_for(:group_document,
						:document => File.open(File.dirname(__FILE__) + 
							'/../assets/edit_save_wireframe.pdf'))
			])
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		} } }
		GroupDocument.destroy_all
	end

#	TODO test trying to create without user

end
