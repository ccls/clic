require 'test_helper'

class GroupDocumentsControllerTest < ActionController::TestCase

	#	no group_id
	assert_no_route(:get,:new)
	assert_no_route(:post,:create)

	#	no id
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	def factory_attributes(options={})
		Factory.attributes_for(:group_document)
	end

	def create_group_document(options={})
		document = Factory(:group_document, {
				:document => File.open(File.dirname(__FILE__) + 
				'/../assets/edit_save_wireframe.pdf')
			}.merge(options))
		assert_not_nil document.id
		document
	end

	#	Simple, quick test to ensure File attachment works.
	test "should create a group_document" do
		assert_difference("GroupDocument.count",1) {
			@document = create_group_document
		}
		document_path = @document.document.path
		assert File.exists?(document_path)
		@document.destroy
		assert !File.exists?(document_path)
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	def self.readers
		@readers ||= site_administrators + %w( 
			group_administrator group_moderator
			group_editor group_reader )
	end

	site_administrators.each do |cu|

		test "should get index with #{cu} login" do
			login_as send(cu)
			get :index
			assert_response :success
			assert_template 'index'
			assert assigns(:documents)
		end

	end

	( all_test_roles - site_administrators ).each do |cu|

		test "should NOT get index with #{cu} login" do
			login_as send(cu)
			get :index
			assert_redirected_to root_path
			assert_not_nil flash[:error]
		end

	end


	#
	#	NOT Attached to a Group
	#
	( all_test_roles - unapproved_users ).each do |cu|

		test "should NOT show groupless group document with #{cu} login and invalid id" do
			login_as send(cu)
			get :show, :id => 0		#	without a valid document, not really a group's document
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT show groupless group document with nil document and #{cu} login" do
			document = create_group_document(:document => nil)
			assert document.document.path.blank?
			login_as send(cu)
			get :show, :id => document.id
			assert_redirected_to root_path
			assert_not_nil flash[:error]
		end

		test "should NOT download document with no document and #{cu} login" do
			document = Factory(:group_document, :document_file_name => 'bogus_file_name')
			assert !File.exists?(document.document.path)
			login_as send(cu)
			get :show, :id => document.id
			assert_redirected_to root_path
			assert_not_nil flash[:error]
		end

		test "should show groupless group document with #{cu} login" do
			load 'group_document.rb'	#	why?  I have to force reloading?
			#	I don't have to do that for documents?
			login_as send(cu)
			document = create_group_document
			assert_nil document.group
			get :show, :id => document.id
			assert_not_nil @response.headers['Content-disposition'].match(
				/attachment;.*pdf/)
			assigns(:group_document).destroy
		end

		test "should get redirect to private s3 groupless group document with #{cu} login" do
			GroupDocument.has_attached_file :document, {
				:s3_headers => {
					'x-amz-storage-class' => 'REDUCED_REDUNDANCY' },
				:s3_permissions => :private,
				:storage => :s3,
				:s3_protocol => 'https',
				:s3_credentials => "#{Rails.root}/config/s3.yml",
				:bucket => 'ccls',
				:path => "group_documents/:id/:filename"
			}
	
			#	Since the REAL S3 credentials are only in production
			#	Bad credentials make exists? return true????
			Rails.stubs(:env).returns('production')
			document = Factory(:group_document, :document_file_name => 'bogus_file_name')
			assert_not_nil document.id
			assert_nil     document.group
			assert !document.document.exists?
			assert !File.exists?(document.document.path)
	
			AWS::S3::S3Object.stubs(:exists?).returns(true)
	
			login_as send(cu)
			get :show, :id => document.id
			assert_response :redirect
			assert_match %r{\Ahttp(s)?://s3.amazonaws.com/ccls/group_documents/\d+/bogus_file_name\.\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, @response.redirected_to

			assigns(:group_document).destroy
		end

	end

	unapproved_users.each do |cu|

		test "should NOT show groupless group document with #{cu} login" do
			login_as send(cu)
			document = create_group_document
			assert_nil document.group
			get :show, :id => document.id
#			assert_not_nil @response.headers['Content-disposition'].match(
#				/attachment;.*pdf/)
			assert_not_nil flash[:error]
			assert_redirected_to root_path
			assigns(:group_document).destroy
		end

	end


	#
	#	Attached to a Group
	#
	readers.each do |cu|

		test "should NOT show group's group document with #{cu} login and invalid id" do
			login_as send(cu)
			get :show, :id => 0		#	without a valid document, not really a group's document
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should show group's group document with #{cu} login" do
			load 'group_document.rb'	#	why?  I have to force reloading?
			#	I don't have to do that for documents?
			login_as send(cu)
			document = create_group_document(:group => @membership.group)
			assert_not_nil document.group
			get :show, :id => document.id
			assert_not_nil @response.headers['Content-disposition'].match(
				/attachment;.*pdf/)
			assigns(:group_document).destroy
		end

		test "should get redirect to private s3 group's group document with #{cu} login" do
			GroupDocument.has_attached_file :document, {
				:s3_headers => {
					'x-amz-storage-class' => 'REDUCED_REDUNDANCY' },
				:s3_permissions => :private,
				:storage => :s3,
				:s3_protocol => 'https',
				:s3_credentials => "#{Rails.root}/config/s3.yml",
				:bucket => 'ccls',
				:path => "group_documents/:id/:filename"
			}
	
			#	Since the REAL S3 credentials are only in production
			#	Bad credentials make exists? return true????
			Rails.stubs(:env).returns('production')
			document = Factory(:group_document, :document_file_name => 'bogus_file_name',
				:group => @membership.group)
			assert_not_nil document.group
			assert !document.document.exists?
			assert !File.exists?(document.document.path)
	
			AWS::S3::S3Object.stubs(:exists?).returns(true)
	
			login_as send(cu)
			get :show, :id => document.id
			assert_response :redirect
			assert_match %r{\Ahttp(s)?://s3.amazonaws.com/ccls/group_documents/\d+/bogus_file_name\.\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, @response.redirected_to

			assigns(:group_document).destroy
		end

	end

	( all_test_roles - readers ).each do |cu|

		test "should NOT show group's group document with #{cu} login" do
			login_as send(cu)
			document = create_group_document(:group => @membership.group)
			assert_not_nil document.group
			get :show, :id => document.id
			assert_redirected_to root_path
			assigns(:group_document).destroy
		end

	end


	#
	#	not logged in tests
	#

	test "should NOT download groupless document without login" do
		document = create_group_document
		get :show, :id => document.id
		assert_redirected_to_login
	end

	test "should NOT download group's document without login" do
		document = create_group_document(:group => @membership.group)
		get :show, :id => document.id
		assert_redirected_to_login
		document.destroy
	end

	test "should NOT get index without login" do
		get :index
		assert_redirected_to_login
	end

end
