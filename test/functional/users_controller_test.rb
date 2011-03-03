require 'test_helper'

class UsersControllerTest < ActionController::TestCase

#	test "should get blank user menu in js without login" do
#		@request.accept = "text/javascript"
#		get :menu
#		assert_response :success
#		assert @response.body.blank?
#	end
#
#	test "should get blank user menu in js with active_user login" do
#		@request.accept = "text/javascript"
#		login_as active_user
#		get :menu
#		assert_response :success
#		assert @response.body.blank?
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
		:actions => [:index,:show,:edit,:update],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes
		Factory.attributes_for(:user)
	end
	def factory_create
		Factory(:user)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })
	assert_no_access_with_login({ 
		:logins => [:interviewer, :editor,:active_user] })
#		:logins => [:moderator,:editor,:employee,:active_user] })
	assert_no_access_without_login
	assert_access_without_login({ 
		:actions => [:new, :create] })

	assert_access_with_https
	assert_no_access_with_http

#	These NEED to be that actual role names and not aliases
#	as the strings are compared
%w( superuser administrator ).each do |cu|

	test "should filter users index by role with #{cu} login" do
		some_other_user = send(cu)	#admin	#	active_user
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
		some_other_user = admin	#	active_user
		login_as send(cu)
		get :index, :role_name => ''
		assert assigns(:users).length >= 2
		assert_nil flash[:error]
		assert_response :success
	end

	test "should ignore invalid role with #{cu} login" do
		login_as send(cu)
		get :index, :role_name => 'suffocator'
#		assert_not_nil flash[:error]
		assert_response :success
	end

end

#%w( admin moderator employee editor active_user ).each do |cu|
%w( super_user admin editor interviewer active_user ).each do |cu|

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


#	#	not really a controller test
	test "should NOT automatically log in new user with my helper" do
		assert_difference('User.count',1) do
			active_user
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

#	test "should get new user without login" do
#		ui = Factory(:user_invitation)
#		get :new, :token => ui.token
#		assert_response :success
#		assert_template 'new'
#	end

#	test "should NOT get new user without invitation token" do
#		get :new
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT get new user without existing invitation token" do
#		get :new, :token => 'blah blah blah'
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT get new user without unused invitation token" do
#		ui = Factory(:user_invitation,:recipient_id => 0)
#		get :new, :token => ui.token
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT get new user with expired invitation token" do
#		pending
##		ui = Factory(:user_invitation,:recipient_id => 0)
##		get :new, :token => ui.token
##		assert_not_nil flash[:error]
##		assert_redirected_to root_path
#	end
#
#	test "should NOT get new user with login" do
#		ui = Factory(:user_invitation)
#		login_as user
#		get :new, :token => ui.token
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#
#	test "should create new user without login" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',1) {
#			post :create, :user => Factory.attributes_for(:user),
#				:token => ui.token
#		}
#		assert_not_nil flash[:notice]
#		assert_redirected_to_login
#	end
#
#	test "should mark invitation as used after use" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',1) {
#			post :create, :user => Factory.attributes_for(:user),
#				:token => ui.token
#		}
#		ui.reload
#		assert_not_nil ui.recipient_id
#		assert_not_nil ui.accepted_at
#		assert_equal ui.recipient_id, assigns(:user).id
#	end
#
#	test "should NOT create new user if invitation update fails" do
#		#
#		#	Nest transactions and savepoints don't work with SQLite
#		#	or with jruby database adapters
#		#	so testing User creation and UserInvitation validation
#		#	can't really be done.  This test is the outer transaction
#		#	so the rollback triggered by the failure doesn't occur 
#		#	until after the completion of the test.
#		#
#		#	Actually, by manually rolling back
#		#	I think that I am breaking the outer transaction
#		#	making testing the controller transaction possible.
#		#	I don't know how kosher this is and I'm actually
#		#	surprised that it works as I haven't read it anywhere.
#		#	Doing this with Sqlite and MySQL both with and
#		#	without jruby and all seem to work.
#		#
#		#	break the outer transaction
#		User.connection.rollback_db_transaction
#		User.connection.decrement_open_transactions
#		ui = Factory(:user_invitation)
#		UserInvitation.any_instance.stubs(:create_or_update).returns(false)
#		assert_difference('User.count',0) do
#			post :create, :user => Factory.attributes_for(:user),
#				:token => ui.token
#		end
#		assert_nil ui.recipient_id
#		assert_nil ui.accepted_at
#		#	killed test transaction so need to cleanup after self
#		ui.sender.destroy
#		ui.destroy
#	end
#
#	test "should NOT create new user with expired invitation token" do
##		ui = Factory(:user_invitation, :recipient_id => 0)
##		assert_difference('User.count',0) {
##			post :create, :user => Factory.attributes_for(:user),
##				:token => ui.token
##		}
##		assert_not_nil flash[:error]
##		assert_redirected_to root_path
#		pending
#	end
#
#	test "should NOT create new user without unused invitation token" do
#		ui = Factory(:user_invitation, :recipient_id => 0)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user),
#				:token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT create new user without existing invitation token" do
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user),
#				:token => 'blah blah blah'
#		}
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT create new user with login" do
#		ui = Factory(:user_invitation)
#		login_as user
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user), 
#				:token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT create new user without username" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:username => nil), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without unique username" do
#		ui = Factory(:user_invitation)
#		u = active_user
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:username => u.username), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without complex password" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:password              => 'mybigbadpassword',
#				:password_confirmation => 'mybigbadpassword'
#			), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without password" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:password => nil), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without password confirmation" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:password_confirmation => nil), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without matching password and confirmation" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:password => 'alpha',
#				:password_confirmation => 'beta'), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without email" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:email => nil), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without formatted email" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:email => 'blah blah blah'), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without unique email" do
#		ui = Factory(:user_invitation)
#		u = active_user
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:email => u.email), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end

	test "should NOT create new user when create fails" do
		User.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('User.count',0) do
			post :create, :user => factory_attributes
		end
		assert assigns(:user)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create new user with invalid user" do
		User.any_instance.stubs(:valid?).returns(false)
		assert_difference('User.count',0) do
			post :create, :user => factory_attributes
		end
		assert assigns(:user)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT update user when update fails" do
		user = create_user(:updated_at => Chronic.parse('yesterday'))
		User.any_instance.stubs(:create_or_update).returns(false)
		login_as user
		deny_changes("User.find(#{user.id}).updated_at") {
			put :update, :id => user.id,
				:user => factory_attributes
		}
		assert assigns(:user)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user with invalid user" do
		user = create_user(:updated_at => Chronic.parse('yesterday'))
		User.any_instance.stubs(:valid?).returns(false)
		login_as user
		deny_changes("User.find(#{user.id}).updated_at") {
			put :update, :id => user.id,
				:user => factory_attributes
		}
		assert assigns(:user)
		assert_response :success
		assert_template 'edit'
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
		put :update, :id => u.id, :user => Factory.attributes_for(:user)
		assert_redirected_to root_path
		assert_not_nil flash[:notice]
	end

	test "should update user with admin login" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user)
		assert_redirected_to root_path
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
		assert_redirected_to root_path
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

	test "should update user without password" do
		#	again odd.  Having password confirmation ignored.
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:password => nil)
		assert_redirected_to root_path
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





#	Destroy  


end
