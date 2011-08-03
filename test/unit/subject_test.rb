require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
#	include TestStartupShutdown
#	include TestSunspot

	assert_should_create_default_object
	assert_should_belong_to(:study)
	assert_should_be_searchable

#	test "should search" do
#		Factory(:subject)
#		Subject.solr_reindex
#		search = Subject.search #do
##      facet :name
##    end
#		assert !search.hits.empty?
#	end

end
