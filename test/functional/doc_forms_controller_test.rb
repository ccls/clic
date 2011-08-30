require 'test_helper'

class DocFormsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'DocForm',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:doc_form)
	end
	def factory_attributes(options={})
		Factory.attributes_for(:doc_form,options)
	end

	with_options :actions => [:new,:create,:edit,:update,:destroy] do |o|
		o.assert_access_with_login({    :logins => site_administrators })
		o.assert_no_access_with_login({ :logins => non_site_administrators })
	end

	with_options :actions => [:show,:index] do |o|
		o.assert_access_with_login({    :logins => approved_users })
		o.assert_no_access_with_login({ :logins => unapproved_users })
	end

	assert_access_with_https
	assert_no_access_with_http 
	assert_no_access_without_login

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :doc_forms_path,
		:show    => { :id => 0 },
		:edit    => { :id => 0 },
		:update  => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should NOT create doc_form with #{cu} login " <<
				"with invalid doc_form" do
			login_as send(cu)
			DocForm.any_instance.stubs(:valid?).returns(false)
			assert_difference('DocForm.count',0) {
				post :create, :doc_form => factory_attributes	#Factory.attributes_for(:doc_form)
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create doc_form with #{cu} login " <<
				"when forum save fails" do
			login_as send(cu)
			DocForm.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('DocForm.count',0) {
				post :create, :doc_form => factory_attributes	#Factory.attributes_for(:doc_form)
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create doc_form with an invalid attachment and #{cu} login" do
			login_as send(cu)
			assert_difference('GroupDocument.count',0) {
			assert_difference('DocForm.count',0) {
				post :create, :doc_form => factory_attributes(
					:group_documents_attributes => [
						Factory.attributes_for(:group_document,
							:title => nil,
							:document => File.open(File.dirname(__FILE__) + 
								'/../assets/edit_save_wireframe.pdf') )])
			} }
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should create doc_form with an attachment and #{cu} login" do
			login_as send(cu)
			assert_difference('GroupDocument.count',1) {
			assert_difference('DocForm.count',1) {
				post :create, :doc_form => factory_attributes(
					:group_documents_attributes => [
						Factory.attributes_for(:group_document,
							:document => File.open(File.dirname(__FILE__) + 
								'/../assets/edit_save_wireframe.pdf') )])
			} }
			assert_not_nil flash[:notice]
			assert_redirected_to assigns(:doc_form)
			assigns(:doc_form).destroy
		end

		test "should create doc_form with multiple attachments and #{cu} login" do
			login_as send(cu)
			assert_difference('GroupDocument.count',2) {
			assert_difference('DocForm.count',1) {
				post :create, :doc_form => factory_attributes(
					:group_documents_attributes => [
						Factory.attributes_for(:group_document,
							:document => File.open(File.dirname(__FILE__) + 
								'/../assets/edit_save_wireframe.pdf') ),
						Factory.attributes_for(:group_document,
							:document => File.open(File.dirname(__FILE__) + 
								'/../assets/edit_save_wireframe.pdf') )
					]
				)
			} }
			assert_not_nil flash[:notice]
			assert_redirected_to assigns(:doc_form)
			assigns(:doc_form).destroy
		end

	end

end
