Rails.application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
#end

#ActionController::Routing::Routes.draw do |map|

	resources :photos
	resource  :directory, :only => :show
	resources :questionnaires do
		member { get :download }
	end

	resources :professions do
		collection { post :order }
	end

#	resource  :inventory, :only => :show
	resources :editor_images, :only => :index
	resources :editor_links,  :only => :index
	resources :announcements
	resources :documents do
		member { get :preview }
	end

	resources :doc_forms
	resources :studies
	resources :contacts, :only => :index
	resources :publication_subjects do
		collection { post :order }
	end
	resources :annual_meetings do
		collection { post :order }
	end
	resources :publications

	resources :group_roles
	resources :memberships, :only => [:index,:update,:destroy,:edit] do
		member { put :approve }
	end
	resources :groups do
		collection { post :order }
		resources :memberships,
			:controller => 'group_memberships' do
			member { put :approve }
		end
		resources :announcements, 
			:controller => 'group_announcements'
	end

#	may want to create a group_forums controller to clarify things

	resources :forums, :except => [:index]
	resources :groups, :shallow => true do
		resources :forums, :only => [:new,:create] do
			resources :topics, :except => [:index] do
				resources :posts, :except => [:show,:index]
			end
		end
	end

	resources :group_documents, :only => [:show,:index]

#	confirm_email 'confirm_email/:id', 
#		:controller => 'email_confirmations', :action => 'confirm'
#	resend_confirm_email 'resend_confirm_email/:id', 
#		:controller => 'email_confirmations', :action => 'resend'
	resources :email_confirmations, :only => [] do
		member do
			get :confirm
			get :resend
		end
	end
	get 'confirm_email/:id' => 'email_confirmations#confirm',
		:as => :confirm_email
	get 'resend_confirm_email/:id' => 'email_confirmations#resend',
		:as => :resend_confirm_email

	
	resource :user_session
	resource :members_only, :only => :show

#	resources :users,	#, :except => :destroy,
#	will cause role route test failure
#		:shallow => true,
#		:member => { :approve => :put },
#		:collection => { :menu => :get } do |user|
	resources :users do
		member { put :approve }
		resources :roles, :only => [:update,:destroy]
		#	separated from user#edit 
	end
	resource :password, :only => [:edit,:update]

	#	:new => initiate reset form gets username or email? (not_logged_in_required)
	#	:create => if user found, sends email with link to show (not_logged_in_required)
	#	:show => confirms reset and shows password edit (not_logged_in_required)
	#	:update => updates password
	#	MUST be plural, otherwise no :id param
	resources :password_resets, :only => [:new,:create,:edit,:update]
	resource  :forgot_username, :only => [:new,:create]

#	signup  '/signup',  :controller => 'users',         :action => 'new'
#	signin  '/signin',  :controller => 'user_sessions', :action => 'new'
#	login   '/login',   :controller => 'user_sessions', :action => 'new'
#	signout '/signout', :controller => 'user_sessions', :action => 'destroy'
#	logout  '/logout',  :controller => 'user_sessions', :action => 'destroy'
	get 'signup' =>  'users#new',
		:as => :signup
	get 'signin' =>  'user_sessions#new',
		:as => :signin
	get 'login' =>   'user_sessions#new',
		:as => :login
	get 'signout' => 'user_sessions#destroy',
		:as => :signout
	get 'logout' =>  'user_sessions#destroy',
		:as => :logout

	resources :locales, :only => :show
	resources :pages do
		collection do 
			get :all
			post :order
		end
	end
	root :to => 'pages#show'
#	root :controller => "pages", :action => "show", :path => [""]

	#	TODO why do I still have this?
	resource  :calendar,       :only => [ :show ]
	resources :search_results, :only => [ :index ]

	#	MUST BE LAST OR WILL BLOCK ALL OTHER ROUTES!
	#	catch all route to manage admin created pages.
	#connect   '*path', :controller => 'pages', :action => 'show'
	get '*path' => 'pages#show'

end
