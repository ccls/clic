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
	assert_should_not_require(:principal_investigators)	#	possible problems due to serialization
	assert_should_not_require(:overview)	#	possible problems due to serialization

	assert_should_act_as_list
	assert_should_have_many(:publications)
	assert_should_have_many(:subjects)

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

end
