require 'test_helper'

class ExposureTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_belong_to :study
#	assert_should_be_searchable
#
#	test "should search" do
#		Exposure.solr_reindex
#		search = Exposure.search
#		assert search.hits.empty?
#		FactoryGirl.create(:exposure)
#		Exposure.solr_reindex
#		search = Exposure.search
#		assert !search.hits.empty?
#	end

	test "types should be an array" do
		exposure = FactoryGirl.build(:exposure)
		assert exposure.types.is_a?(Array)
	end

	test "windows should be an array" do
		exposure = FactoryGirl.build(:exposure)
		assert exposure.windows.is_a?(Array)
	end

	test "assessments should be an array" do
		exposure = FactoryGirl.build(:exposure)
		assert exposure.assessments.is_a?(Array)
	end

	test "forms_of_contact should be an array" do
		exposure = FactoryGirl.build(:exposure)
		assert exposure.forms_of_contact.is_a?(Array)
	end

	test "locations_of_use should be an array" do
		exposure = FactoryGirl.build(:exposure)
		assert exposure.locations_of_use.is_a?(Array)
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_exposure

end
