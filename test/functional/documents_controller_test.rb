require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Document',
		:actions => [:new,:create,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create(options={})
		FactoryGirl.create(:document,options)
	end
	def factory_attributes(options={})
		FactoryGirl.attributes_for(:document,options)
	end

	assert_access_with_login({ :logins => site_editors })

	assert_no_access_with_login({ :logins => non_site_editors })

	assert_no_access_without_login

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	site_editors.each do |cu|

		test "should NOT download document with nil document and #{cu} login" do
			document = FactoryGirl.create(:document)
			assert document.document.path.blank?
			login_as send(cu)
			get :show, :id => document.id
			assert_redirected_to preview_document_path(document)
			assert_not_nil flash[:error]
		end

		test "should NOT download document with no document and #{cu} login" do
			document = FactoryGirl.create(:document, :document_file_name => 'bogus_file_name')
			assert !File.exists?(document.document.path)
			login_as send(cu)
			get :show, :id => document.id
			assert_redirected_to preview_document_path(document)
			assert_not_nil flash[:error]
		end

		test "should NOT download nonexistant document with #{cu} login" do
			assert !File.exists?('some_fake_file_name.doc')
			login_as send(cu)
			get :show, :id => 'some_fake_file_name',:format => 'doc'
			assert_redirected_to documents_path
			assert_not_nil flash[:error]
		end

		test "should preview document with document and #{cu} login" do
			document = FactoryGirl.create(:document)
			login_as send(cu)
			get :preview, :id => document.id
			assert_response :success
			assert_nil flash[:error]
		end

		test "should download document by id with document and #{cu} login" do
			document = Document.create!(FactoryGirl.attributes_for(:document, 
				:document => Rack::Test::UploadedFile.new(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf')))
			login_as send(cu)
			get :show, :id => document.reload.id
			assert_nil flash[:error]
			#	reload is important or the content disposition will be blank
			assert_not_nil @response.headers['Content-Disposition'].match(
				/attachment;.*pdf/)
			remove_object_and_document_attachment(document)
		end

		test "should download document by name with document and #{cu} login" do
			document = Document.create!(FactoryGirl.attributes_for(:document, 
				:document => Rack::Test::UploadedFile.new(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf')))
			login_as send(cu)
			get :show, :id => 'edit_save_wireframe',
				:format => 'pdf'
			assert_nil flash[:error]
			assert_not_nil @response.headers['Content-Disposition'].match(
				/attachment;.*pdf/)
			remove_object_and_document_attachment(document)
		end

	end


	( all_test_roles + ['no_login'] ).each do |cu|

		test "should get redirect to private s3 document with #{cu} login" do
			#	Since the REAL S3 credentials are only in production
			Document.has_attached_file :document,
				YAML::load(ERB.new(IO.read(File.expand_path(
					File.join(File.dirname(__FILE__),'../..','config/document.yml')
				))).result)['production']

			document = FactoryGirl.create(:document, :document_file_name => 'bogus_file_name')
			assert !document.document.exists?
			assert !File.exists?(document.document.path)

			AWS::S3::S3Object.any_instance.stubs(:exists?).returns(true)
			assert document.document.exists?

			login_as send(cu)
			get :show, :id => document.id
			assert_response :redirect
			assert_match %r{\Ahttp(s)?://clic.s3.amazonaws.com/documents/\d+/bogus_file_name\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, 
				@response.redirect_url

			Document.has_attached_file :document,
				YAML::load(ERB.new(IO.read(File.expand_path(
					File.join(File.dirname(__FILE__),'../..','config/document.yml')
				))).result)['test']
		end

	end

	( non_site_editors + ['no_login'] ).each do |cu|

		test "should NOT download document with nil document and #{cu} login" do
			document = FactoryGirl.create(:document)
			assert document.document.path.blank?
			login_as send(cu) #unless cu == 'NOLOGIN'
			get :show, :id => document.id
			assert_redirected_to preview_document_path(document)
			assert_not_nil flash[:error]
		end

		test "should NOT download document with no document and #{cu} login" do
			document = FactoryGirl.create(:document, :document_file_name => 'bogus_file_name')
			assert !File.exists?(document.document.path)
			login_as send(cu) #unless cu == 'NOLOGIN'
			get :show, :id => document.id
			assert_redirected_to preview_document_path(document)
			assert_not_nil flash[:error]
		end

		test "should NOT download nonexistant document with #{cu} login" do
			assert !File.exists?('some_fake_file_name.doc')
			login_as send(cu) #unless cu == 'NOLOGIN'
			get :show, :id => 'some_fake_file_name',:format => 'doc'
			assert_redirected_to documents_path
			assert_not_nil flash[:error]
		end

		test "should preview document with document and #{cu} login" do
			document = FactoryGirl.create(:document)
			login_as send(cu) #unless cu == 'NOLOGIN'
			get :preview, :id => document.id
			assert_response :success
			assert_nil flash[:error]
		end

		test "should download document by id with document and #{cu} login" do
			document = Document.create!(FactoryGirl.attributes_for(:document, 
				:document => Rack::Test::UploadedFile.new(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf')))
			login_as send(cu) #unless cu == 'NOLOGIN'
			get :show, :id => document.reload.id
			assert_nil flash[:error]
			#	reload is important or the content disposition will be blank
			assert_not_nil @response.headers['Content-Disposition'].match(
				/attachment;.*pdf/)
			remove_object_and_document_attachment(document)
		end

		test "should download document by name with document and #{cu} login" do
			document = Document.create!(FactoryGirl.attributes_for(:document, 
				:document => Rack::Test::UploadedFile.new(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf')))
			login_as send(cu) #unless cu == 'NOLOGIN'
			get :show, :id => 'edit_save_wireframe',
				:format => 'pdf'
			assert_nil flash[:error]
			assert_not_nil @response.headers['Content-Disposition'].match(
				/attachment;.*pdf/)
			remove_object_and_document_attachment(document)
		end

	end

	add_strong_parameters_tests( :document, [:title, :document, :abstract] )

end
