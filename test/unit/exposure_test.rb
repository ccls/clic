require 'test_helper'

class ExposureTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_belong_to :study
	assert_should_be_searchable

	test "should search" do
		Exposure.solr_reindex
		search = Exposure.search
		assert search.hits.empty?
		Factory(:exposure)
		Exposure.solr_reindex
		search = Exposure.search
		assert !search.hits.empty?
	end

end
