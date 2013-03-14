require 'test_helper'

class AnnualMeetingTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
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
			@object = create_annual_meeting(
				:current_user => user,
				:group_documents_attributes => [
					group_doc_attributes_with_attachment
			])
			assert !@object.new_record?, 
				"#{@object.errors.full_messages.to_sentence}"
		} } }
		@object.destroy
	end

	test "should NOT create annual_meeting with nested attributes for group_documents" <<
			" without user" do
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',0) {
		assert_difference('AnnualMeeting.count',0) {
			@object = create_annual_meeting(
				:group_documents_attributes => [
					group_doc_attributes_with_attachment
			])
			assert @object.errors.matching?('group_documents.user_id', :blank)
		} } }
#		@object.group_documents = []
#	None created
#		@object.destroy
	end

	test "should update annual_meeting with nested attributes for group_documents" do
		user = Factory(:user)
		object = create_annual_meeting
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',1) {
		assert_difference('AnnualMeeting.count',0) {
			object.update_attributes(
				:current_user => user,
				:group_documents_attributes => [
					group_doc_attributes_with_attachment
			])
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		} } }
		object.destroy
	end

	test "should NOT update annual_meeting with nested attributes for group_documents" <<
			" without user" do
		object = create_annual_meeting
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',0) {
		assert_difference('AnnualMeeting.count',0) {
			object.update_attributes(
				:group_documents_attributes => [
					group_doc_attributes_with_attachment
			])
			assert object.errors.matching?('group_documents.user_id', :blank)
		} } }
		#	acts_as_list's remove_from_list tries to save the object
		#	again or something, with the invalid group documents and fails.
		#	Removing the documents makes it happier.
#	removed restriction from database, but left in app so all is ok now
#		object.group_documents = []
		object.destroy
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_annual_meeting

end
