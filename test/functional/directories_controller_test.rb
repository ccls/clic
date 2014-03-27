require 'test_helper'

class DirectoriesControllerTest < ActionController::TestCase

	#	gotta have a membership to use
	setup :create_a_membership

	approved_users.each do |cu|

		%w( last_name title ).each do |attr|

			#
			#	These will include the User from :create_a_membership and the User logged in
			#	( they are a bit unpredictable in the sorting, so remove them )
			#

			test "should recall from session find users and" <<
					" order by #{attr} with #{cu} login" do
				users = 3.times.collect{|i| FactoryGirl.create(:user, attr => "999#{i}" )}
				login_as u = send(cu)
				session[:order] = attr
				get :show
				assert_response :success
				users.each{|user| assert assigns(:members).to_a.include?(user) }
				assert_equal assigns(:members).to_a - [u] - [@membership.user], users
			end

			test "should recall from session find users and" <<
					" order by #{attr} dir asc with #{cu} login" do
				users = 3.times.collect{|i| FactoryGirl.create(:user, attr => "999#{i}" )}
				login_as u = send(cu)
				session[:order] = attr
				session[:dir] = 'asc'
				get :show
				assert_response :success
				users.each{|user| assert assigns(:members).to_a.include?(user) }
				assert_equal assigns(:members).to_a - [u] - [@membership.user], users
			end

			test "should recall from session find users and" <<
					" order by #{attr} dir desc with #{cu} login" do
				users = 3.times.collect{|i| FactoryGirl.create(:user, attr => "999#{i}" )}
				login_as u = send(cu)
				session[:order] = attr
				session[:dir] = 'desc'
				get :show
				assert_response :success
				users.each{|user| assert assigns(:members).to_a.include?(user) }
				assert_equal assigns(:members).reverse.to_a - [u] - [@membership.user], users
			end

			test "should recall from session find users and" <<
					" order by #{attr} invalid dir with #{cu} login" do
				users = 3.times.collect{|i| FactoryGirl.create(:user, attr => "999#{i}" )}
				login_as u = send(cu)
				session[:order] = attr
				session[:dir] = 'invalid'
				get :show
				assert_response :success
				users.each{|user| assert assigns(:members).to_a.include?(user) }
				assert_equal assigns(:members).to_a - [u] - [@membership.user], users
			end

		end	#	%w( last_name title ).each do |attr|

		test "should get member directory with #{cu} login" do
			login_as send(cu)
			get :show
			assert_response :success
			assert_template 'show'
			assert !assigns(:members).empty?
		end

		test "should search directory by bogus first name with #{cu} login" do
			login_as send(cu)
			get :show, :first_name => 'bogus'
			assert_response :success
			assert_template 'show'
			assert assigns(:members).empty?
		end

		test "should search directory by first name with #{cu} login" do
			user = send(cu)
			assert_not_nil user.first_name
			login_as user
			get :show, :first_name => user.first_name
			assert_response :success
			assert_template 'show'
			assert !assigns(:members).empty?
		end

		test "should search directory by bogus last name with #{cu} login" do
			login_as send(cu)
			get :show, :last_name => 'bogus'
			assert_response :success
			assert_template 'show'
			assert assigns(:members).empty?
		end

		test "should search directory by last name with #{cu} login" do
			user = send(cu)
			assert_not_nil user.last_name
			login_as user
			get :show, :last_name => user.last_name
			assert_response :success
			assert_template 'show'
			assert !assigns(:members).empty?
		end

		test "should search directory by bogus profession id with #{cu} login" do
			login_as send(cu)
			get :show, :profession_id => 'bogus'
			assert_response :success
			assert_template 'show'
			assert assigns(:members).empty?
		end

		test "should search directory by profession id with #{cu} login" do
			user = send(cu)
			assert_not_nil user.profession_ids.first
			login_as user
			get :show, :profession_id => user.profession_ids.first
			assert_response :success
			assert_template 'show'
			assert !assigns(:members).empty?
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
