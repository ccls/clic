require 'test_helper'

class QuestionnaireTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:study_id)
	assert_should_require(:title)
	assert_should_require_attribute_length(:title, :in => 4..250)
	assert_should_initially_belong_to(:study)

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

	test "should create with attachment" do
		assert_difference('Questionnaire.count',1) {
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
		record = Questionnaire.new(:document => document)
		assert_equal "ITs_1234_UPPERCASE_.PNG", record.document_file_name
		document.close
	end

	test "should use local filesystem to store attachment in test" do
		questionnaire = FactoryGirl.create(:questionnaire, :document_file_name => 'bogus_file_name')
		assert !questionnaire.document.exists?
		assert !File.exists?(questionnaire.document.path)
		assert_equal :filesystem, questionnaire.document.options[:storage]
	end

	test "should use amazon to store attachment in production" do
		Rails.stubs(:env).returns('production')
		load 'questionnaire.rb'
		questionnaire = FactoryGirl.create(:questionnaire, :document_file_name => 'bogus_file_name')
		assert !questionnaire.document.exists?
		assert !File.exists?(questionnaire.document.path)

		assert_equal :s3, questionnaire.document.options[:storage]
		assert_equal :private, questionnaire.document.options[:s3_permissions]

 		assert_match %r{\Ahttp(s)?://clic.s3.amazonaws.com/questionnaires/\d+/bogus_file_name\?AWSAccessKeyId=\w+&Expires=\d+&Signature=.+\z}, questionnaire.document.expiring_url

		# WE MUST UNDO these has_attached_file modifications
		Rails.unstub(:env)
		load 'questionnaire.rb'
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_questionnaire

end
