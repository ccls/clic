require 'test_helper'

class PublicationSubjectsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'PublicationSubject',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:publication_subject)
	end
	def factory_attributes(options={})
		Factory.attributes_for(:publication_subject,options)
	end

	assert_access_with_https
	assert_access_with_login({ :logins => site_administrators })
	assert_no_access_with_http 
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_no_access_without_login
	assert_orderable

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :publication_subjects_path,
		:show    => { :id => 0 },
		:edit    => { :id => 0 },
		:update  => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should NOT create publication_subject with #{cu} login " <<
				"with invalid publication_subject" do
			login_as send(cu)
			PublicationSubject.any_instance.stubs(:valid?).returns(false)
			assert_difference('PublicationSubject.count',0) {
				post :create, :publication_subject => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create publication_subject with #{cu} login " <<
				"when publication_subject save fails" do
			login_as send(cu)
			PublicationSubject.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('PublicationSubject.count',0) {
				post :create, :publication_subject => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

	end

end
