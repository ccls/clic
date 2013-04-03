require 'test_helper'

class GroupRolesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'GroupRole',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_group_role
	}
	def factory_attributes(options={})
		FactoryGirl.attributes_for(:group_role,options)
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login({    :logins => site_administrators })
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_no_access_without_login
#	assert_access_with_https
#	assert_no_access_with_http

end
