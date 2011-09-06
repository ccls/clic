require 'test_helper'

class ProfessionsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Profession',
		:actions => [:new,:create,:show,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:profession)
	end
	def factory_attributes(options={})
		Factory.attributes_for(:profession,options)
	end

	assert_access_with_https
	assert_access_with_login({ :logins => site_administrators })
	assert_no_access_with_http 
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_no_access_without_login

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :professions_path,
		:show    => { :id => 0 },
		:edit    => { :id => 0 },
		:update  => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should order professions with #{cu} login" do
			login_as send(cu)
			professions = []
			3.times{ professions.push(factory_create) }
			before_ids = Profession.all.collect(&:id)
			post :order, :professions => before_ids.reverse
			after_ids = Profession.all.collect(&:id)
			assert_equal after_ids, before_ids.reverse
			assert_redirected_to professions_path
		end

		test "should NOT order professions without professions " <<
				"with #{cu} login" do
			login_as send(cu)
			post :order
			assert_not_nil flash[:error]
			assert_redirected_to professions_path
		end

		test "should NOT create profession with #{cu} login " <<
				"with invalid profession" do
			login_as send(cu)
			Profession.any_instance.stubs(:valid?).returns(false)
			assert_difference('Profession.count',0) {
				post :create, :profession => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create profession with #{cu} login " <<
				"when profession save fails" do
			login_as send(cu)
			Profession.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('Profession.count',0) {
				post :create, :profession => factory_attributes
			}
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

	end

	non_site_administrators.each do |cu|

		test "should NOT order professions with #{cu} login" do
			login_as send(cu)
			professions = []
			3.times{ professions.push(factory_create) }
			before_ids = Profession.all.collect(&:id)
			post :order, :professions => before_ids.reverse
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	test "should NOT order professions without login" do
		professions = []
		3.times{ professions.push(factory_create) }
		before_ids = Profession.all.collect(&:id)
		post :order, :professions => before_ids.reverse
		assert_redirected_to_login
	end

end
