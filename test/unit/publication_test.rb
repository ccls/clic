require 'test_helper'

class PublicationTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_require(:journal)
	assert_should_require(:publication_year)
	assert_should_require(:author_last_name)
	assert_should_require(:publication_subject)
	assert_should_require(:study)
	assert_should_not_require(:other_publication_subject)

	assert_should_initially_belong_to(:publication_subject)
	assert_should_initially_belong_to(:study)
	assert_should_have_many(:group_documents, :as => :attachable)
	assert_should_require_attribute_length( :title, :journal,
		:publication_year, :author_last_name, :other_publication_subject,  
			:maximum => 250 )

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

	test "should create publication with nested attributes for group_documents" do
		user = Factory(:user)
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',1) {
		assert_difference('Publication.count',1) {
			object = create_publication(
				:current_user => user,
				:group_documents_attributes => [
					Factory.attributes_for(:group_document,
						:document => File.open(File.dirname(__FILE__) + 
							'/../assets/edit_save_wireframe.pdf') )
			])
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		} } }
		GroupDocument.destroy_all
	end

	test "should NOT create publication with nested attributes for group_documents" <<
			" without user" do
		user = Factory(:user)
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',0) {
		assert_difference('Publication.count',0) {
			object = create_publication(
				:group_documents_attributes => [
					Factory.attributes_for(:group_document,
						:document => File.open(File.dirname(__FILE__) + 
							'/../assets/edit_save_wireframe.pdf') )
			])
			assert object.errors.on_attr_and_type('group_documents.user',:blank)
		} } }
		GroupDocument.destroy_all
	end

	test "should require other_publication_subject if publication_subject is other" do
		assert_difference('Publication.count',0) {
			object = create_object(:publication_subject_id => PublicationSubject.find(:first,
				:conditions => { :name => 'Other' }).id)
			assert object.errors.on_attr_and_type(:other_publication_subject, :blank)
		}
	end

#	TODO test should require publication year between 1900 and this year

	test "should require publication_year between 1900 and this year" do
pending
	end

end
