require 'test_helper'

class SubjectTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:study)
	assert_should_be_searchable

#	TODO
#	assert_not_required ...
#			t.integer :subid
#			t.string :case_status
#			t.string :subtype
#			t.string :sex
#			t.string :race
#			t.text :biospecimens

	test "should return several fields as to_s" do
		object = create_object({
			:clic_id => "12345678",
			:case_status => "Case",
			:leukemia_type => "ALL",
			:immunophenotype => "T-Cell"
		})
		assert_equal "#{object}",
			"Subject: #{object.clic_id} : #{object.case_status} : #{object.leukemia_type} : #{object.immunophenotype}"
	end

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
