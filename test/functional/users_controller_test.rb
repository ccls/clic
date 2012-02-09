require 'test_helper'

class UsersControllerTest < ActionController::TestCase

#	test "should get blank user menu in js without login" do
#		@request.accept = "text/javascript"
#		get :menu
#		assert_response :success
#		assert @response.body.blank?
#	end
#
#	test "should NOT get blank user menu in js with unapproved_user login" do
#		@request.accept = "text/javascript"
#		login_as unapproved_user
#		get :menu
#		assert_response :success
#		assert !@response.body.blank?
#	end
#
#	test "should get user menu in js with admin login" do
#		@request.accept = "text/javascript"
#		login_as admin_user
#		get :menu
#		assert_response :success
#		assert !@response.body.blank?
#		assert_match /jQuery/, @response.body
##jQuery(function(){
##	jQuery('div#menu').append('<ul id="PrivateNav"><li><a href="/pages">Pages</a></li><li><a href="/photos">Photos</a></li><li><a href="/users">Users</a></li><li><a href="/documents">Documents</a></li><li><a href="/logout">Logout</a></li></ul><!-- id=PrivateNav -->');
##	// application_user_menu returns NO SINGLE QUOTES.
##/*
##		decodeURI(encodeURI()))
##*/
##});
#	end

	ASSERT_ACCESS_OPTIONS = {
		:model => 'User',
		:actions => [:index,:show,:edit,:update,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes(options={})
		Factory.attributes_for(:user,options)
	end
	def factory_create(options={})
		Factory(:user,options)
	end

	#	a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login({    :logins => site_administrators })
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_no_access_without_login
	assert_access_without_login({ :actions => [:new, :create] })
	assert_access_with_https
	assert_no_access_with_http

	#	These NEED to be that actual role names and not aliases
	#	as the strings are compared
	site_administrators.each do |cu|
	
		test "should filter users index by role with #{cu} login" do
			some_other_user = send(cu)	#admin	#	unapproved_user
			login_as send(cu)
			get :index, :role_name => cu	#'administrator'
			assert assigns(:users).length >= 2
			assigns(:users).each do |u|
				assert u.role_names.include?(cu)	#('administrator')
			end
			assert_nil flash[:error]
			assert_response :success
		end
	
		test "should ignore empty role_name with #{cu} login" do
			some_other_user = admin	#	unapproved_user
			login_as send(cu)
			get :index, :role_name => ''
			assert assigns(:users).length >= 2
			assert_nil flash[:error]
			assert_response :success
		end
	
		test "should ignore invalid role with #{cu} login" do
			login_as send(cu)
			get :index, :role_name => 'suffocator'
			assert_response :success
		end

		test "should approve user with #{cu} login" do
			u = unapproved_user
			assert !u.approved?
			login_as send(cu)
			assert_changes("User.find(#{u.id}).approved") do
				put :approve, :id => u.id
			end
			assert  u.reload.approved?
			assert_redirected_to users_path
		end
	
		test "should NOT approve user with #{cu} login and update fails" do
			u = unapproved_user
			assert !u.approved?
			login_as send(cu)
			User.any_instance.stubs(:create_or_update).returns(false)
			deny_changes("User.find(#{u.id}).approved") do
				put :approve, :id => u.id
			end
			assert !u.reload.approved?
			assert_not_nil flash[:error]
			assert_redirected_to users_path
		end
	
	end


	non_site_administrators.each do |cu|

		test "should NOT approve user with #{cu} login" do
			u = unapproved_user
			assert !u.approved?
			login_as send(cu)
			deny_changes("User.find(#{u.id}).approved") do
				put :approve, :id => u.id
			end
			assert !u.approved?
			assert_redirected_to root_path
		end

	end


	
	all_test_roles.each do |cu|
	
		test "should NOT get user info with invalid id with #{cu} login" do
			login_as send(cu)
			get :show, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to users_path
		end
	
		test "should get #{cu} info with self login" do
			u = send(cu)
			login_as u
			get :show, :id => u.id
			assert_response :success
			assert_not_nil assigns(:user)
			assert_equal u, assigns(:user)
		end
	
	end


	#	not really a controller test
	test "should NOT automatically log in new user with my helper" do
		assert_difference('User.count',1) do
			unapproved_user
		end
		assert_equal Hash.new, session
		assert_nil UserSession.find
	end

	#	not really a controller test
	test "should NOT automatically log in new user with create" do
		assert_difference('User.count',1) do
			User.create(Factory.attributes_for(:user))
		end
		assert_equal Hash.new, session
		assert_nil UserSession.find
	end

	test "should get new user without login" do
		get :new
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get new user with login" do
		login_as unapproved_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should create new user without login" do
		ActionMailer::Base.deliveries.clear	#	remove existing emails
		#	confirm_email and new_user_email
		assert_difference('ActionMailer::Base.deliveries.length',2) {
		assert_difference('User.count',1) {
			post :create, :user => Factory.attributes_for(:user)
		} }
		assert_match /#{assigns(:user).reload.perishable_token}/,
			ActionMailer::Base.deliveries.detect{|m| m.subject =~ /CLIC Email Confirmation/ }.to_s
		assert_not_logged_in
		assert_not_nil flash[:notice]
		assert_redirected_to login_path
	end

	test "should create new user with membership requests" do
		ActionMailer::Base.deliveries.clear	#	remove existing emails
		#	confirm_email and new_user_email
		assert_difference('ActionMailer::Base.deliveries.length',2) {
		assert_difference('Membership.count',3) {
		assert_difference('User.count',1) {
			post :create, :user => Factory.attributes_for(:user,{
				:membership_requests => {
					Group['Ethics'].id   => { :group_role_id => GroupRole['editor'].id },
					Group['Methods'].id  => { :group_role_id => GroupRole['editor'].id },
					Group['Outcomes'].id => { :group_role_id => GroupRole['editor'].id }
				}})
		} } }
		assert assigns(:user)
		assert_equal 3, assigns(:user).memberships.length
		assigns(:user).memberships.each do |m|
			assert_equal m.group_role, GroupRole['editor']
			assert !m.approved?
			assert [Group['Ethics'],Group['Methods'],Group['Outcomes']].include?(m.group)
		end
		assert_equal assigns(:user).memberships.collect(&:group_id).sort,
			[Group['Ethics'],Group['Methods'],Group['Outcomes']].collect(&:id).sort
		assert_match /#{assigns(:user).reload.perishable_token}/,
			ActionMailer::Base.deliveries.detect{|m| m.subject =~ /CLIC Email Confirmation/ }.to_s
		assert_not_logged_in
		assert_not_nil flash[:notice]
		assert_redirected_to login_path
	end

	test "should NOT create new user with login" do
		login_as unapproved_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user)
		} }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create new user without username" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user, :username => nil)
		} }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without unique username" do
		u = unapproved_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user, :username => u.username)
		} }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without complex password" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:password              => 'mybigbadpassword',
				:password_confirmation => 'mybigbadpassword'
			)
		} }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without password" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user, :password => nil)
		} }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without password confirmation" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user, :password_confirmation => nil)
		} }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without matching password and confirmation" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:password => 'alpha',
				:password_confirmation => 'beta')
		} }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without email" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:email => nil)
		} }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without formatted email" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:email => 'blah blah blah')
		} }
		assert_not_nil flash[:error]
		assert_response :success
	end

	test "should NOT create new user without unique email" do
		u = unapproved_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:email => u.email)
		} }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user when create fails" do
		User.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => factory_attributes
		} }
		assert assigns(:user)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create new user with invalid user" do
		User.any_instance.stubs(:valid?).returns(false)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('User.count',0) {
			post :create, :user => factory_attributes
		} }
		assert assigns(:user)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should edit user with admin login" do
		u = user
		login_as admin
		get :edit, :id => u.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit user with self login" do
		u = user
		login_as u
		get :edit, :id => u.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit user with just user login" do
		u = user
		login_as user
		get :edit, :id => u.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT edit user without login" do
		u = user
		get :edit, :id => u.id
		assert_redirected_to_login
		assert_not_nil flash[:error]
	end

	test "should NOT edit user without valid id" do
		u = user
		login_as admin
		get :edit, :id => 0
		assert_redirected_to users_path
		assert_not_nil flash[:error]
	end

	test "should NOT edit user without id" do
		u = user
		login_as admin
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should update user with self login" do
		u = user
		login_as u
		#	email address will change here triggering email confirmation email
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			put :update, :id => u.id, :user => Factory.attributes_for(:user)
		}
		assert_equal u, assigns(:user)
		assert_redirected_to user_path(assigns(:user))
		assert_not_nil flash[:notice]
	end

	test "should update user with admin login" do
		u = user
		login_as admin
		#	email address will change here triggering email confirmation email
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			put :update, :id => u.id, :user => Factory.attributes_for(:user)
		}
		assert_equal u, assigns(:user)
		assert_redirected_to user_path(assigns(:user))
		assert_not_nil flash[:notice]
	end

	test "should NOT update user with just login" do
		u = user
		login_as user
		put :update, :id => u.id, :user => Factory.attributes_for(:user)
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT update user without login" do
		u = user
		put :update, :id => u.id, :user => Factory.attributes_for(:user)
		assert_redirected_to_login
		assert_not_nil flash[:error]
	end

	test "should NOT update user without valid id" do
		u = user
		login_as admin
		put :update, :id => 0, :user => Factory.attributes_for(:user)
		assert_redirected_to users_path
		assert_not_nil flash[:error]
	end

	test "should NOT update user without id" do
		u = user
		login_as admin
		assert_raise(ActionController::RoutingError){
			put :update, :user => Factory.attributes_for(:user)
		}
	end

	test "should update user without user" do
		# kinda pointless
		u = user
		login_as admin
		put :update, :id => u.id
		assert_equal u, assigns(:user)
		assert_redirected_to user_path(assigns(:user))
		assert_not_nil flash[:notice]
	end

	test "should NOT update user without username" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:username => nil)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user without unique username" do
		u1 = Factory(:user)
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:username => u1.username)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

#
#	Passwords are now editted in their own controller,
#	but is still possible.
#
	test "should update user without password" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:password => nil, :password_confirmation => nil)
		assert_equal u, assigns(:user)
		assert_redirected_to user_path(assigns(:user))
		assert_not_nil flash[:notice]
	end

	test "should NOT update user without complex password" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:password              => 'mybigbadpassword',
			:password_confirmation => 'mybigbadpassword')
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user without matching password and confirmation" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:password => 'alphaV@1!d', 
			:password_confirmation => 'betaV@1!d')
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user without password confirmation" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:password_confirmation => nil)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user when update fails" do
		user = create_user(:updated_at => ( Time.now - 1.day ) )
		User.any_instance.stubs(:create_or_update).returns(false)
		login_as user
		deny_changes("User.find(#{user.id}).updated_at") {
			put :update, :id => user.id, :user => factory_attributes
		}
		assert assigns(:user)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user with invalid user" do
		user = create_user(:updated_at => ( Time.now - 1.day ) )
		User.any_instance.stubs(:valid?).returns(false)
		login_as user
		deny_changes("User.find(#{user.id}).updated_at") {
			put :update, :id => user.id, :user => factory_attributes
		}
		assert assigns(:user)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

end
