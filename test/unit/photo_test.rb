require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

	assert_should_require(:title)

	test "should create photo" do
		assert_difference 'Photo.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_photo

end
