require 'test_helper'

class PublicationTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_require(:journal)
	assert_should_require(:publication_year)
	assert_should_require(:author_last_name)
	assert_should_require(:publication_subject_ids)
	assert_should_require(:study_ids)
	assert_should_not_require(:other_publication_subject)
#	assert_should_have_many(:group_documents, :as => :attachable)

	assert_should_require_attribute_length( :title, :journal,
		:author_last_name, :other_publication_subject,  :url,
			:maximum => 250 )

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

#	test "should create publication with nested attributes for group_documents" do
#		user = Factory(:user)
#		assert_difference('User.count',0) {
#		assert_difference('GroupDocument.count',1) {
#		assert_difference('Publication.count',1) {
#			@object = create_publication(
#				:current_user => user,
#				:group_documents_attributes => [
#					group_doc_attributes_with_attachment
#			])
#			assert !@object.new_record?, 
#				"#{@object.errors.full_messages.to_sentence}"
#		} } }
#		@object.destroy
#	end
#
#	test "should NOT create publication with nested attributes for group_documents" <<
#			" without user" do
#		assert_difference('User.count',0) {
#		assert_difference('GroupDocument.count',0) {
#		assert_difference('Publication.count',0) {
#			@object = create_publication(
#				:group_documents_attributes => [
#					group_doc_attributes_with_attachment
#			])
#			assert @object.errors.on_attr_and_type('group_documents.user',:blank)
#		} } }
#		@object.destroy
#	end
#
#	test "should update publication with nested attributes for group_documents" do
#		object = create_publication
#		user = Factory(:user)
#		assert_difference('User.count',0) {
#		assert_difference('GroupDocument.count',1) {
#		assert_difference('Publication.count',0) {
#			object.update_attributes(
#				:current_user => user,
#				:group_documents_attributes => [
#					group_doc_attributes_with_attachment
#			])
#			assert !object.new_record?, 
#				"#{object.errors.full_messages.to_sentence}"
#		} } }
#		object.destroy
#	end
#
#	test "should NOT update publication with nested attributes for group_documents" <<
#			" without user" do
#		object = create_publication
#		assert_difference('User.count',0) {
#		assert_difference('GroupDocument.count',0) {
#		assert_difference('Publication.count',0) {
#			object.update_attributes(
#				:group_documents_attributes => [
#					group_doc_attributes_with_attachment
#			])
#			assert object.errors.on_attr_and_type('group_documents.user',:blank)
#		} } }
#		object.destroy
#	end

#	test "should require other_publication_subject if publication_subject is other" do
#		assert_difference('Publication.count',0) {
#			object = create_object(:publication_subject_id => PublicationSubject.find(:first,
#				:conditions => { :name => 'Other' }).id)
#			assert object.errors.on_attr_and_type(:other_publication_subject, :blank)
#		}
#	end

	test "should require publication_year after 1899" do
		assert_difference('Publication.count',0) {
			object = create_object(:publication_year => 1899)
			assert object.errors.on_attr_and_type(:publication_year, :inclusion)
		}
	end

	test "should allow publication_year of 1900" do
		assert_difference('Publication.count',1) {
			object = create_object(:publication_year => 1900)
		}
	end

	test "should require publication_year before #{Chronic.parse('next year').year}" do
		assert_difference('Publication.count',0) {
			object = create_object(:publication_year => Chronic.parse('next year').year)
			assert object.errors.on_attr_and_type(:publication_year, :inclusion)
		}
	end

	test "should allow publication_year of #{Time.now.year}" do
		assert_difference('Publication.count',1) {
			object = create_object(:publication_year => Time.now.year)
		}
	end

end
