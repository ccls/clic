require 'test_helper'

class StudyTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:name)
	assert_should_require_unique(:name)
	assert_should_not_require(:world_region)
	assert_should_not_require(:country)
	assert_should_not_require(:design)
	assert_should_not_require(:recruitment)
	assert_should_not_require(:target_age_group)
	assert_should_not_require(:overview)
	assert_should_protect(:principal_investigators)

	assert_should_act_as_list
#	assert_should_have_many(:publications)
	assert_should_have_many(:subjects)
	assert_should_have_many(:exposures)
	assert_should_have_many(:questionnaires)

	assert_should_require_attribute_length( :name, :maximum => 250 )
	assert_should_require_attribute_length( :world_region, :maximum => 250 )
	assert_should_require_attribute_length( :country, :maximum => 250 )
	assert_should_require_attribute_length( :design, :maximum => 250 )
	assert_should_require_attribute_length( :recruitment, :maximum => 250 )
	assert_should_require_attribute_length( :target_age_group, :maximum => 250 )
	assert_should_require_attribute_length( :overview, :maximum => 65000 )

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

	test "should set principal_investigators with principal_investigator_names" do
		assert_difference('Study.count',1) {
			object = create_object(:principal_investigator_names => "  Dave , Simon , ,,   ")
			assert !object.principal_investigators.empty?
			assert_equal 2, object.principal_investigators.length
		}
	end

	#	This won't work at create as the Factory gives it a name
	test "updating study_name should set name" do
		object = create_object
		object.update_attribute(:study_name, 'Arbitrary')
		assert_equal object.reload.name, 'Arbitrary'
	end

	test "updating study_design should set design" do
		object = create_object
		object.update_attribute(:study_design, 'Arbitrary')
		assert_equal object.reload.design, 'Arbitrary'
	end

end
