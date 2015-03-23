require 'test_helper'

class StudiesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Study',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create(options={})
		FactoryGirl.create(:study,options)
	end
	def factory_attributes(options={})
		FactoryGirl.attributes_for(:study,options)
	end

	assert_access_with_login({    :logins => site_administrators })
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_no_access_without_login

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	add_strong_parameters_tests( :study, [
		:name, :principal_investigator_names, :contact_info, 
		:world_region, :country, :design, :target_age_group, 
		:recruitment, :overview ])

end
