require 'test_helper'

class DocFormTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title, :abstract)
	assert_should_require_attribute_length( :title,    :maximum => 250 )
	assert_should_require_attribute_length( :abstract, :maximum => 65000 )

	assert_should_have_many(:group_documents, :as => :attachable)

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

	test "should create doc_form with nested attributes for group_documents" do
		user = Factory(:user)
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',1) {
		assert_difference('DocForm.count',1) {
			object = create_doc_form(
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

	test "should NOT create doc_form with nested attributes for group_documents" <<
			" without user" do
		user = Factory(:user)
		assert_difference('User.count',0) {
		assert_difference('GroupDocument.count',0) {
		assert_difference('DocForm.count',0) {
			object = create_doc_form(
				:group_documents_attributes => [
					Factory.attributes_for(:group_document,
						:document => File.open(File.dirname(__FILE__) + 
							'/../assets/edit_save_wireframe.pdf'))
			])
			assert object.errors.on_attr_and_type('group_documents.user',:blank)
		} } }
		GroupDocument.destroy_all
	end

end
