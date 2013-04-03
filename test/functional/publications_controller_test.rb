require 'test_helper'

class PublicationsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Publication',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create(options={})
		FactoryGirl.create(:publication,options)
	end
	def factory_attributes(options={})
		FactoryGirl.attributes_for(:publication,options)
	end

	with_options :actions => [:new,:create,:edit,:update,:destroy] do |o|
		o.assert_access_with_login({    :logins => site_administrators })
		o.assert_no_access_with_login({ :logins => non_site_administrators })
	end
	with_options :actions => [:show,:index] do |o|
		o.assert_access_with_login({    :logins => approved_users })
		o.assert_no_access_with_login({ :logins => unapproved_users })
	end
#	assert_access_with_https
#	assert_no_access_with_http 
	assert_no_access_without_login

	# a @membership is required so that those group roles will work
	setup :create_a_membership

#	site_administrators.each do |cu|
#
#		test "should NOT create publication with an invalid attachment and #{cu} login" do
##	doesn't work as expected for nested attributes
##			GroupDocument.any_instance.stubs(:valid?).returns(false)
#			login_as send(cu)
#			assert_difference('GroupDocument.count',0) {
#			assert_difference('Publication.count',0) {
#				post :create, :publication => factory_attributes(
#					:group_documents_attributes => [ group_doc_attributes_with_attachment(
#						:title => nil ) ])
#			} }
#			assert_not_nil flash[:error]
#			assert_response :success
#			assert_template 'new'
#		end
##						FactoryGirl.attributes_for(:group_document,
##							:title => nil,
##							:document => File.open(File.dirname(__FILE__) + 
##								'/../assets/edit_save_wireframe.pdf') )])
#
#		test "should create publication with an attachment and #{cu} login" do
#			login_as send(cu)
#			assert_difference('GroupDocument.count',1) {
#			assert_difference('Publication.count',1) {
#				post :create, :publication => factory_attributes(
#					:group_documents_attributes => [ group_doc_attributes_with_attachment ])
#			} }
#			assert_not_nil flash[:notice]
#			assert_redirected_to assigns(:publication)
#			assigns(:publication).destroy
#		end
#
#		test "should create publication with multiple attachments and #{cu} login" do
#			login_as send(cu)
#			assert_difference('GroupDocument.count',2) {
#			assert_difference('Publication.count',1) {
#				post :create, :publication => factory_attributes(
#					:group_documents_attributes => [
#						group_doc_attributes_with_attachment,
#						group_doc_attributes_with_attachment
#					])
#			} }
#			assert_not_nil flash[:notice]
#			assert_redirected_to assigns(:publication)
#			assigns(:publication).destroy
#		end
#
#		test "should add attachment on update with #{cu} login" do
#			login_as send(cu)
#			object = create_publication
#			assert_difference('GroupDocument.count',1) {
##			assert_changes("Publication.find(#{object.id}).updated_at") {
#				put :update, :id => object.id,
#					:publication => factory_attributes(
#						:group_documents_attributes => [ group_doc_attributes_with_attachment ])
#			} #}
#			assert_not_nil flash[:notice]
#			assert_redirected_to publications_path
#			assigns(:publication).destroy	
#		end
#
#	end

end
