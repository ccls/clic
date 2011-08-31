require 'test_helper'

class StudiesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Study',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:study)
	end
	def factory_attributes(options={})
		Factory.attributes_for(:study,options)
	end

	assert_access_with_login({    :logins => site_administrators })
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_access_with_https
	assert_no_access_with_http 
	assert_no_access_without_login

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :studies_path,
		:show    => { :id => 0 },
		:edit    => { :id => 0 },
		:update  => { :id => 0 },
		:destroy => { :id => 0 }
	)

#	approved_users.each do |cu|
#
#		test "should get study contact info with #{cu} login" do
#			login_as send(cu)
#			get :contact
#			assert_response :success
#			assert_template 'contact'
#		end
#
#	end
#
#	unapproved_users.each do |cu|
#
#		test "should NOT get study contact info with #{cu} login" do
#			login_as send(cu)
#			get :contact
#			assert_not_nil flash[:error]
#			assert_redirected_to root_path
#		end
#
#	end
#
#	test "should NOT get study contact info without login" do
#		get :contact
#		assert_redirected_to_login
#	end

end
