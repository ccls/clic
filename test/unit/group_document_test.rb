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
	end

	test "should create with attachment" do
		assert_difference('GroupDocument.count',1) {
			@object = create_object(
				:document => File.open(File.dirname(__FILE__) + 
					'/../assets/edit_save_wireframe.pdf')
			)
		}
		@object.destroy
	end


#	TODO figure out how to cleanup ALL of the uploaded paperclip
#				attachments so that all of the bad characters like apostrophes
#				are removed

	test "should cleanup attachment file name" do
		bad_file_name = File.join(RAILS_ROOT, 'test', 'fixtures', 
				%Q{IT's,  UPPERCASE!.JPG})
#		document = File.new(bad_file_name,'w')
#		gd = GroupDocument.new(:document => document )
#		puts gd.document.methods.sort
#		document.close
#		document.delete
	end

end
