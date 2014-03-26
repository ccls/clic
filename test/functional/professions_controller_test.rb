require 'test_helper'

class ProfessionsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Profession',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create(options={})
		FactoryGirl.create(:profession,options)
	end
	def factory_attributes(options={})
		FactoryGirl.attributes_for(:profession,options)
	end

	assert_access_with_login({ :logins => site_administrators })
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_no_access_without_login
	assert_orderable

	# a @membership is required so that those group roles will work
	setup :create_a_membership

end
