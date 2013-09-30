require 'test_helper'

class GroupDocumentTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_not_require(:description)
	assert_should_initially_belong_to( :user )	#, :post )
	assert_should_belong_to( :group )
	assert_should_require_attribute_length( :title,       :maximum => 250 )
	assert_should_require_attribute_length( :description, :maximum => 65000 )
	assert_should_protect(:group_id, :user_id)

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
		assert_equal object.title, object.to_s
	end

	test "should create with attachment" do
		assert_difference('GroupDocument.count',1) {
			@object = create_object(
				:document => Rack::Test::UploadedFile.new(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf')
			)
		}
		@object.destroy
	end

	test "should cleanup attachment file name" do
		bad_file_name = File.join(Rails.root, 'test', 'assets', %Q{IT's, 1234 UPPERCASE!.PNG})
		document = File.open(bad_file_name,'rb')
		record = GroupDocument.new(:document => document)
		assert_equal "ITs_1234_UPPERCASE_.PNG", record.document_file_name
		document.close
	end


	test "should use local filesystem to store attachment in test" do
		group_document = FactoryGirl.create(:group_document, :document_file_name => 'bogus_file_name')
		assert !group_document.document.exists?
		assert !File.exists?(group_document.document.path)
		assert_equal :filesystem, group_document.document.options[:storage]
	end

	test "should use amazon to store attachment in production" do
		Rails.stubs(:env).returns('production')
		load 'group_document.rb'
		group_document = FactoryGirl.create(:group_document, :document_file_name => 'bogus_file_name')
		assert !group_document.document.exists?
		assert !File.exists?(group_document.document.path)

		assert_equal :s3, group_document.document.options[:storage]
		assert_equal :private, group_document.document.options[:s3_permissions]

 		assert_match %r{\Ahttp(s)?://clic.s3.amazonaws.com/group_documents/\d+/bogus_file_name\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, group_document.document.expiring_url

		# WE MUST UNDO these has_attached_file modifications
		Rails.unstub(:env)
		load 'group_document.rb'
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_group_document

end
