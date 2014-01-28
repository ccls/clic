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
		FactoryGirl.attributes_for(:group_document,options)
	end

	def create_group_document(options={})
		document = FactoryGirl.create(:group_document, {
				:document => Rack::Test::UploadedFile.new(File.dirname(__FILE__) + 
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
		@document.document.destroy
		@document.destroy
		assert !File.exists?(document_path)
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	site_administrators.each do |cu|

		test "should get index with #{cu} login" do
			login_as send(cu)
			get :index
			assert_response :success
			assert_template 'index'
			assert assigns(:documents)
		end

	end

	non_site_administrators.each do |cu|

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
	approved_users.each do |cu|

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
			document = FactoryGirl.create(:group_document, :document_file_name => 'bogus_file_name')
			assert !File.exists?(document.document.path)
			login_as send(cu)
			get :show, :id => document.id
			assert_redirected_to root_path
			assert_not_nil flash[:error]
		end

		test "should show groupless group document with #{cu} login" do
			login_as send(cu)
			document = create_group_document
			assert_nil document.group
			get :show, :id => document.reload.id

			assert_response :success

			#	reload is important or the content disposition will be blank
			assert_not_nil @response.headers['Content-Disposition'].match(
				/attachment;.*pdf/)
			assigns(:group_document).document.destroy
			assigns(:group_document).destroy
		end

		test "should get redirect to private s3 groupless group document with #{cu} login" do
			#	Since the REAL S3 credentials are only in production
			#	Bad credentials make exists? return true????
			Rails.stubs(:env).returns('production')
			load 'group_document.rb'

			document = FactoryGirl.create(:group_document, :document_file_name => 'bogus_file_name')
			assert_not_nil document.id
			assert_nil     document.group
			assert !document.document.exists?
			assert !File.exists?(document.document.path)
	
			AWS::S3::S3Object.any_instance.stubs(:exists?).returns(true)
			assert document.document.exists?
	
			login_as send(cu)
			get :show, :id => document.id
			assert_response :redirect
			assert_match %r{\Ahttp(s)?://clic.s3.amazonaws.com/group_documents/\d+/bogus_file_name\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, @response.redirect_url

			#	WE MUST UNDO these has_attached_file modifications
			Rails.unstub(:env)
			load 'group_document.rb'
		end

	end

	unapproved_users.each do |cu|

		test "should NOT show groupless group document with #{cu} login" do
			login_as send(cu)
			document = create_group_document
			assert_nil document.group
			get :show, :id => document.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
			assigns(:group_document).document.destroy
			assigns(:group_document).destroy
		end

	end


	#
	#	Attached to a Group
	#
	group_readers.each do |cu|

		test "should NOT show group's group document with #{cu} login and invalid id" do
			login_as send(cu)
			get :show, :id => 0		#	without a valid document, not really a group's document
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should show group's group document with #{cu} login" do
			login_as send(cu)
			document = create_group_document(:group => @membership.group)
			assert_not_nil document.group
			get :show, :id => document.reload.id

			assert_response :success

			#	reload is important or the content disposition will be blank
			assert_not_nil @response.headers['Content-Disposition'].match(
				/attachment;.*pdf/)
			assigns(:group_document).document.destroy
			assigns(:group_document).destroy
		end

		test "should get redirect to private s3 group's group document with #{cu} login" do
			#	Since the REAL S3 credentials are only in production
			#	Bad credentials make exists? return true????
			Rails.stubs(:env).returns('production')
			load 'group_document.rb'

			document = FactoryGirl.create(:group_document, :document_file_name => 'bogus_file_name',
				:group => @membership.group)
			assert_not_nil document.id
			assert_not_nil document.group
			assert !document.document.exists?
			assert !File.exists?(document.document.path)
	
			AWS::S3::S3Object.any_instance.stubs(:exists?).returns(true)
			assert document.document.exists?
	
			login_as send(cu)
			get :show, :id => document.id
			assert_response :redirect
			assert_match %r{\Ahttp(s)?://clic.s3.amazonaws.com/group_documents/\d+/bogus_file_name\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, @response.redirect_url

			#	WE MUST UNDO these has_attached_file modifications
			Rails.unstub(:env)
			load 'group_document.rb'
		end

	end

	non_group_readers.each do |cu|

		test "should NOT show group's group document with #{cu} login" do
			login_as send(cu)
			document = create_group_document(:group => @membership.group)
			assert_not_nil document.group
			get :show, :id => document.id
			assert_redirected_to root_path
			assigns(:group_document).document.destroy
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
		document.document.destroy
		document.destroy
	end

	test "should NOT download group's document without login" do
		document = create_group_document(:group => @membership.group)
		get :show, :id => document.id
		assert_redirected_to_login
		document.document.destroy
		document.destroy
	end

	test "should NOT get index without login" do
		get :index
		assert_redirected_to_login
	end

end
