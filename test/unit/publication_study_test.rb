require 'test_helper'

class PublicationStudyTest < ActiveSupport::TestCase

#	NOTE As a rich join, this is a bit excessive anyhow
#	Due to the factory setup, this will create 2
#	assert_should_create_default_object
	assert_should_initially_belong_to(:publication)
	assert_should_initially_belong_to(:study)
	assert_should_protect( :publication_id )
	assert_should_protect( :study_id )

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_publication_study

end
