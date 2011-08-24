require 'test_helper'

class PublicationStudyTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:publication)
	assert_should_initially_belong_to(:study)
	assert_should_protect( :publication_id )
	assert_should_protect( :study_id )

end
