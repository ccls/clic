ActionController::Routing::Routes.draw do |map|

	map.root :controller => "pages", :action => "show", :path => [""]

	map.resource  :calendar,   :only => [ :show ]

	#	MUST BE LAST OR WILL BLOCK ALL OTHER ROUTES!
	#	catch all route to manage admin created pages.
	map.connect   '*path', :controller => 'pages', :action => 'show'

end
