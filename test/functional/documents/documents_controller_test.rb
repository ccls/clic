require 'test_helper'

if( g = Gem.source_index.find_name('jakewendt-simply_documents').last ) && 
	!defined?(SimplyDocuments::DocumentsControllerTest)
	require 'simply_documents'
	require g.full_gem_path + '/test/functional/documents/documents_controller_test'
end

SimplyDocuments::DocumentsControllerTest.class_eval do
	tests DocumentsController

%w( interviewer reader active_user NOLOGIN ).each do |cu|

	test "should get redirect to private s3 document with #{cu} login" do
		Document.has_attached_file :document, {
			:s3_headers => {
				'x-amz-storage-class' => 'REDUCED_REDUNDANCY' },
			:s3_permissions => :private,
			:storage => :s3,
			:s3_protocol => 'https',
			:s3_credentials => "#{Rails.root}/config/s3.yml",
			:bucket => 'ccls',
			:path => "documents/:id/:filename"
		}

		#	Since the REAL S3 credentials are only in production
		#	Bad credentials make exists? return true????
		Rails.stubs(:env).returns('production')
		document = Factory(:document, :document_file_name => 'bogus_file_name')
		assert !document.document.exists?
		assert !File.exists?(document.document.path)

		AWS::S3::S3Object.stubs(:exists?).returns(true)

		login_as send(cu) unless cu == 'NOLOGIN'
		get :show, :id => document.id
		assert_response :redirect
		assert_match %r{\Ahttp(s)?://s3.amazonaws.com/ccls/documents/\d+/bogus_file_name\.\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, @response.redirected_to
	end

	test "should NOT download document with nil document and #{cu} login" do
		document = Factory(:document)
		assert document.document.path.blank?
		login_as send(cu) unless cu == 'NOLOGIN'
		get :show, :id => document.id
		assert_redirected_to preview_document_path(document)
		assert_not_nil flash[:error]
	end

	test "should NOT download document with no document and #{cu} login" do
		document = Factory(:document, :document_file_name => 'bogus_file_name')
		assert !File.exists?(document.document.path)
		login_as send(cu) unless cu == 'NOLOGIN'
		get :show, :id => document.id
		assert_redirected_to preview_document_path(document)
		assert_not_nil flash[:error]
	end

	test "should NOT download nonexistant document with #{cu} login" do
		assert !File.exists?('some_fake_file_name.doc')
		login_as send(cu) unless cu == 'NOLOGIN'
		get :show, :id => 'some_fake_file_name',:format => 'doc'
		assert_redirected_to documents_path
		assert_not_nil flash[:error]
	end

	test "should preview document with document and #{cu} login" do
		document = Factory(:document)
		login_as send(cu) unless cu == 'NOLOGIN'
		get :preview, :id => document.id
		assert_response :success
		assert_nil flash[:error]
	end

	test "should download document by id with document and #{cu} login" do
		document = Document.create!(Factory.attributes_for(:document, 
			:document => File.open(File.dirname(__FILE__) + 
				'/../../assets/edit_save_wireframe.pdf')))
		login_as send(cu) unless cu == 'NOLOGIN'
		get :show, :id => document.reload.id
		assert_nil flash[:error]
		assert_not_nil @response.headers['Content-disposition'].match(
			/attachment;.*pdf/)
		document.destroy
	end

	test "should download document by name with document and #{cu} login" do
		document = Document.create!(Factory.attributes_for(:document, 
			:document => File.open(File.dirname(__FILE__) + 
				'/../../assets/edit_save_wireframe.pdf')))
		login_as send(cu) unless cu == 'NOLOGIN'
		get :show, :id => 'edit_save_wireframe',
			:format => 'pdf'
		assert_nil flash[:error]
		assert_not_nil @response.headers['Content-disposition'].match(
			/attachment;.*pdf/)
		document.destroy
	end

end

	undef_method :test_should_NOT_download_document_with_active_user_login
	undef_method :test_should_NOT_download_document_with_interviewer_login
	undef_method :test_should_NOT_download_document_with_reader_login
	undef_method :test_should_NOT_preview_document_with_active_user_login
	undef_method :test_should_NOT_preview_document_with_interviewer_login
	undef_method :test_should_NOT_preview_document_with_reader_login

####################################################################################
#
#		login is no longer required to preview and download
#

	undef_method :test_should_NOT_download_document_without_login
	undef_method :test_should_NOT_preview_document_without_login

end
