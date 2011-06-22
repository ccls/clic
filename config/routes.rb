ActionController::Routing::Routes.draw do |map|

	map.resources :editor_images, :only => :index
	map.resources :editor_links,  :only => :index
	map.resources :events
	map.resources :announcements
	map.resources :documents, :member => { :preview => :get }

	map.resources :doc_forms
	map.resources :studies
	map.resources :publication_subjects
	map.resources :annual_meetings
	map.resources :publications

	map.resources :group_roles
	map.resources :memberships, :only => [:index,:update,:destroy,:edit],
		:member => { :approve => :put }
	map.resources :groups do |group|
		group.resources :memberships,
			:controller => 'group_memberships',
			:member => { :approve => :put }
		group.resources :events, 
			:controller => 'group_events'
		group.resources :announcements, 
			:controller => 'group_announcements'
	end

#	may want to create a group_forums controller to clarify things

	map.resources :forums, :only => [:new,:create]
	map.resources :groups, :shallow => true do |group|
		group.resources :forums, :only => [:new,:create,:show] do |forum|
			forum.resources :topics, :only => [:new,:create,:show] do |topic|
				topic.resources :posts, :only => [:new, :create ]
			end
		end
	end

	map.resources :group_documents, :only => [:show,:index]

	map.confirm_email 'confirm_email/:id', 
		:controller => 'email_confirmations', :action => 'confirm'
	map.resend_confirm_email 'resend_confirm_email/:id', 
		:controller => 'email_confirmations', :action => 'resend'
	
	map.resource :user_session
	map.resource :members_only, :only => :show

	map.resources :users, :except => :destroy,
#	will cause role route test failure
#		:shallow => true,
		:member => { :approve => :put },
		:collection => { :menu => :get } do |user|
		user.resources :roles, :only => [:update,:destroy]
		#	separated from user#edit 
	end
	map.resource :password, :only => [:edit,:update]

	#	:new => initiate reset form gets username or email? (not_logged_in_required)
	#	:create => if user found, sends email with link to show (not_logged_in_required)
	#	:show => confirms reset and shows password edit (not_logged_in_required)
	#	:update => updates password
	#	MUST be plural, otherwise no :id param
	map.resources :password_resets, :only => [:new,:create,:edit,:update]
	map.resource  :forgot_username, :only => [:new,:create]

	map.signup  '/signup',  :controller => 'users',         :action => 'new'
	map.signin  '/signin',  :controller => 'user_sessions', :action => 'new'
	map.login   '/login',	  :controller => 'user_sessions', :action => 'new'
	map.signout '/signout', :controller => 'user_sessions', :action => 'destroy'
	map.logout  '/logout',  :controller => 'user_sessions', :action => 'destroy'

	map.root :controller => "pages", :action => "show", :path => [""]

	map.resource  :calendar,   :only => [ :show ]
	map.resources :search_results,   :only => [ :index ]

	#	MUST BE LAST OR WILL BLOCK ALL OTHER ROUTES!
	#	catch all route to manage admin created pages.
	map.connect   '*path', :controller => 'pages', :action => 'show'

end
