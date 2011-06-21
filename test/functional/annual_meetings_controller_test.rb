require 'test_helper'

class AnnualMeetingsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'AnnualMeeting',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:annual_meeting)
	end
	def factory_attributes
		Factory.attributes_for(:annual_meeting)
	end

	assert_access_with_https
	assert_access_with_login({ :logins => site_administrators })
	assert_no_access_with_http 
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_no_access_without_login

	# a @membership is required so that those group roles will work
	setup :create_a_membership

#	assert_no_access_with_login(
#		:attributes_for_create => nil,
#		:method_for_create => nil,
#		:actions => nil,
#		:suffix => " and invalid id",
#		:login => :superuser,
#		:redirect => :documents_path,
#		:edit => { :id => 0 },
#		:update => { :id => 0 },
#		:destroy => { :id => 0 }
#	)

#	TODO add tests with attachments

end
