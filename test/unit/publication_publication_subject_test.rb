require 'test_helper'

class PublicationPublicationSubjectTest < ActiveSupport::TestCase

#	NOTE As a rich join, this is a bit excessive anyhow
#	Due to the factory setup, this will create 2
#	assert_should_create_default_object
	assert_should_initially_belong_to(:publication)
	assert_should_initially_belong_to(:publication_subject)
	assert_should_protect( :publication_id )
	assert_should_protect( :publication_subject_id )

end
