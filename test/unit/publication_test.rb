require 'test_helper'

class PublicationTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:title)
	assert_should_require(:journal)
	assert_should_require(:publication_year)
	assert_should_require(:author_last_name)

	assert_should_have_many(:publication_subjects)
	assert_should_have_many(:studies)

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

end
