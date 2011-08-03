require 'test_helper'

class SubjectTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:study)
	assert_should_be_searchable

#			t.integer :subid
#			t.string :case_status
#			t.string :subtype
#			t.string :sex
#			t.string :race
#			t.text :biospecimens

	test "should search" do
		Subject.solr_reindex
		search = Subject.search
		assert search.hits.empty?
		Factory(:subject)
		Subject.solr_reindex
		search = Subject.search
		assert !search.hits.empty?
	end

end
