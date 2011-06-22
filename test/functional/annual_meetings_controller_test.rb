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

	site_administrators.each do |cu|

		test "should NOT create annual_meeting with #{cu} login " <<
				"with invalid annual_meeting" do
			login_as send(cu)
			AnnualMeeting.any_instance.stubs(:valid?).returns(false)
			assert_difference('AnnualMeeting.count',0) {
				post :create, :annual_meeting => Factory.attributes_for(:annual_meeting)
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create annual_meeting with #{cu} login " <<
				"when forum save fails" do
			login_as send(cu)
			AnnualMeeting.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('AnnualMeeting.count',0) {
				post :create, :annual_meeting => Factory.attributes_for(:annual_meeting)
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

	end

end
