require 'test_helper'

class AnnualMeetingsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'AnnualMeeting',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:annual_meeting)
	end
	def factory_attributes(options={})
		Factory.attributes_for(:annual_meeting,options)
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
		:redirect => :annual_meetings_path,
		:show    => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should NOT create annual_meeting with an invalid attachment and #{cu} login" do
			login_as send(cu)
			assert_difference('GroupDocument.count',0) {
			assert_difference('AnnualMeeting.count',0) {
				post :create, :annual_meeting => factory_attributes(
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

		test "should create annual_meeting with an attachment and #{cu} login" do
			login_as send(cu)
			assert_difference('GroupDocument.count',1) {
			assert_difference('AnnualMeeting.count',1) {
				post :create, :annual_meeting => factory_attributes(
					:group_documents_attributes => [
						Factory.attributes_for(:group_document,
							:document => File.open(File.dirname(__FILE__) + 
								'/../assets/edit_save_wireframe.pdf') )])
			} }
			assert_not_nil flash[:notice]
			assert_redirected_to assigns(:annual_meeting)
			assigns(:annual_meeting).destroy
		end

		test "should create annual_meeting with multiple attachments and #{cu} login" do
			login_as send(cu)
			assert_difference('GroupDocument.count',2) {
			assert_difference('AnnualMeeting.count',1) {
				post :create, :annual_meeting => factory_attributes(
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
			assert_redirected_to assigns(:annual_meeting)
			assigns(:annual_meeting).destroy
		end

	end

end
