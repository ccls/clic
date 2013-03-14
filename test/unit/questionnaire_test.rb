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
#				:document => File.open(File.dirname(__FILE__) + 
#					'/../assets/edit_save_wireframe.pdf')
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

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_questionnaire

end
