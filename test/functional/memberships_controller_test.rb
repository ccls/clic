require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Membership',
		:actions => [:update,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_membership
	}
	def factory_attributes(options={})
		Factory.attributes_for(:membership,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })
	assert_no_access_with_login({ 
		:logins => [:editor,:interviewer,:reader,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

end
