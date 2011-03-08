ActionController::Routing::Routes.draw do |map|

	map.resources :group_roles
	map.resources :groups, :shallow => true do |group|
		group.resources :memberships
	end

#	map.resource :email_confirmation, :only => :create
	map.confirm_email 'confirm_email/:id', 
		:controller => 'email_confirmations', :action => 'confirm'
	map.resend_confirm_email 'resend_confirm_email/:id', 
		:controller => 'email_confirmations', :action => 'resend'
	
	map.resource :user_session
	map.resource :members_only, :only => :show

	map.resources :users, :except => :destroy,
#	will cause role route test failure
#		:shallow => true,
		:collection => { :menu => :get } do |user|
		user.resources :roles, :only => [:update,:destroy]
  	user.resources :memberships
	end

	map.signup   '/signup',  :controller => 'users',		:action => 'new'
	map.signin   '/signin',  :controller => 'user_sessions', :action => 'new'
	map.login    '/login',	 :controller => 'user_sessions', :action => 'new'
	map.logout   '/signout', :controller => 'user_sessions', :action => 'destroy'
	map.logout   '/logout',  :controller => 'user_sessions', :action => 'destroy'
#	map.activate '/activate/:id', :controller => 'accounts', :action => 'show'
#	map.forgot_password '/forgot_password',    :controller => 'passwords', :action => 'new'
#	map.reset_password  '/reset_password/:id', :controller => 'passwords', :action => 'edit'
#	map.change_password '/change_password',    :controller => 'accounts',  :action => 'edit'

	map.root :controller => "pages", :action => "show", :path => [""]

	map.resource  :calendar,   :only => [ :show ]
	map.resources :search_results,   :only => [ :index ]

	#	MUST BE LAST OR WILL BLOCK ALL OTHER ROUTES!
	#	catch all route to manage admin created pages.
	map.connect   '*path', :controller => 'pages', :action => 'show'

end
