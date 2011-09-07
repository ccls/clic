require 'test_helper'

class DirectoriesControllerTest < ActionController::TestCase

	#	gotta have a membership to use
	setup :create_a_membership

	approved_users.each do |cu|

		test "should get member directory with #{cu} login" do
			login_as send(cu)
			get :show
			assert_response :success
			assert_template 'show'
		end

	end

	unapproved_users.each do |cu|

		test "should not get member directory with #{cu} login" do
			login_as send(cu)
			get :show
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	test "should not get member directory without login" do
		get :show
		assert_redirected_to_login
	end

	[nil,'asc','desc','bogus'].each do |dir|

#		[nil,'last_name','profession','title','bogus'].each do |order|
		[nil,'last_name','title','bogus'].each do |order|

			test "should get member directory with dir:#{dir}:, order:#{order}: and administrator login" do
				login_as send(:administrator)
				get :show, :dir => dir, :order => order
				assert_response :success
				assert_template 'show'
			end

		end

	end

	[:first_name,:last_name,:profession_id].each do |field|

		test "should search directory with field #{field}" do
			login_as send(:administrator)
			get :show, field => 'irrelevant'
			assert_response :success
			assert_template 'show'
		end

	end

end
