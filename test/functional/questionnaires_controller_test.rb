require 'test_helper'

class QuestionnairesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Questionnaire',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create(options={})
		Factory(:questionnaire,options)
	end
	def factory_attributes(options={})
		Factory.attributes_for(:questionnaire,{
			:study_id => Study.first.id
		}.merge(options))
	end

	assert_access_with_https
	assert_no_access_with_http 
	assert_no_access_without_login

	with_options :actions => [:new,:create,:edit,:update,:destroy] do |o|
		o.assert_access_with_login({    :logins => site_administrators })
		o.assert_no_access_with_login({ :logins => non_site_administrators })
	end

	with_options :actions => [:show,:index] do |o|
		o.assert_access_with_login({    :logins => approved_users })
		o.assert_no_access_with_login({ :logins => unapproved_users })
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

#	assert_no_access_with_login(
#		:attributes_for_create => nil,
#		:method_for_create => nil,
#		:actions => nil,
#		:suffix => " and invalid id",
#		:login => :superuser,
#		:redirect => :questionnaires_path,
#		:show    => { :id => 0 }
#	)

	site_administrators.each do |cu|

		test "should create questionnaire with #{cu} login and attachment" do
			login_as send(cu)
			assert_difference('Questionnaire.count',1) {
				post :create, :questionnaire => factory_attributes(
					:document => File.open(File.dirname(__FILE__) + 
						'/../assets/edit_save_wireframe.pdf'))
			}
			assert_nil flash[:error]
			assert_not_nil flash[:notice]
			assert_redirected_to assigns(:questionnaire)
			#	we must clean up after ourselves to remove the upload
			assigns(:questionnaire).destroy
		end

	end

	approved_users.each do |cu|

		test "should download questionnaire with #{cu} login" do
			questionnaire = factory_create(
				:document => File.open(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf'))
			login_as send(cu)
			get :download, :id => questionnaire.id
			assert_nil flash[:error]
			assert_not_nil @response.headers['Content-disposition'].match(
				/attachment;.*pdf/)
			#	we must clean up after ourselves to remove the upload
			questionnaire.destroy
		end

		test "should download S3 questionnaire with #{cu} login" do
			#	Since the REAL S3 credentials are only in production
			#	Bad credentials make exists? return true????
			Rails.stubs(:env).returns('production')
			load 'questionnaire.rb'

			questionnaire = Factory(:questionnaire, :document_file_name => 'bogus_file_name')
			assert !questionnaire.document.exists?
			assert !File.exists?(questionnaire.document.path)

			AWS::S3::S3Object.stubs(:exists?).returns(true)

			login_as send(cu)
			get :download, :id => questionnaire.id
			assert_response :redirect
			assert_match %r{\Ahttp(s)?://s3.amazonaws.com/clic/questionnaires/\d+/bogus_file_name\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, @response.redirected_to

			#	WE MUST UNDO these has_attached_file modifications
			Rails.unstub(:env)
			load 'questionnaire.rb'
		end

		test "should NOT download questionnaire with #{cu} login and no document" do
			questionnaire = factory_create
			login_as send(cu)
			get :download, :id => questionnaire.id
			assert_not_nil flash[:error]
			assert_redirected_to questionnaire
		end

		test "should NOT download questionnaire with #{cu} login and missing document" do
			questionnaire = factory_create(
				:document => File.open(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf'))
			File.delete(questionnaire.document.path)
			login_as send(cu)
			get :download, :id => questionnaire.id
			assert_not_nil flash[:error]
			assert_redirected_to questionnaire
		end

	end

	unapproved_users.each do |cu|

		test "should NOT download questionnaire with #{cu} login" do
			questionnaire = factory_create(
				:document => File.open(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf'))
			login_as send(cu)
			get :download, :id => questionnaire.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
			#	we must clean up after ourselves to remove the upload
			questionnaire.destroy
		end

	end

	test "should NOT download questionnaire without login" do
		questionnaire = factory_create(
			:document => File.open(File.dirname(__FILE__) + 
				'/../assets/edit_save_wireframe.pdf'))
		get :download, :id => questionnaire.id
		assert_redirected_to_login
		#	we must clean up after ourselves to remove the upload
		questionnaire.destroy
	end

end
