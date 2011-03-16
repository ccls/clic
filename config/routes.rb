ActionController::Routing::Routes.draw do |map|

#	remove password from user edit form?
#	only on user new
#	due to requiring confirmation but doesn't check or change if blank?
#	map.resource :password
#	:new => initiate reset form gets username or email? (not_logged_in_required)
#	:create => if user found, sends email with link to show (not_logged_in_required)
#	:show => confirms username and forwards to password edit (not_logged_in_required)
#	:edit => password and password_confirmation only (works with password reset or just by choice)
#	:update => updates password

	map.resources :events
	map.resources :announcements
	map.resources :documents, :member => { :preview => :get }

	map.resources :group_roles
  map.resources :memberships, :only => [:index,:update,:destroy]
	map.resources :groups do |group|
		group.resources :memberships,
			:controller => 'group_memberships'
#
#	I don't like the duplication of group here, but
#	I want to separate events from group_events
#	and announcements from group_announcements
#	otherwise the controller would get pretty ugly
#	It would be nice if I could say
#
#	group.resources :events, :controller => 'group_events'
#
#	but this would cause problems if shallow
#	so DO NOT USE SHALLOW => TRUE
#
		group.resources :events, 
			:controller => 'group_events'
		group.resources :announcements, 
			:controller => 'group_announcements'

#	make this go away
		group.resources :documents, 
			:controller => 'group_documents'
#	|document|
#			document.resources :comments,
#				:controller => 'group_document_comments'
#	this'll get outta hand if comments can have documents
#		which can have comments
#		which can have documents ........
#	end
#		group.resources :forums, :shallow => true do |forum|
#			forum.resources :topics do |topic|
#				topic.resources :posts do |post|
#					post.resources :documents, :controller => 'group_documents'
#				end
#			end
#		end
	end

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
#  	user.resources :memberships
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
