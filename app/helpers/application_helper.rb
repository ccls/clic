module ApplicationHelper

	def application_root_menu
		out = "<ul id='GlobalNav'>\n"
		out << Page.roots.collect do |page|
			"<li>" << link_to( page.menu(session[:locale]), 
				ActionController::Base.relative_url_root.to_s + page.path,
				:id => "menu_#{dom_id(page)}",
				:class => ((page == @page.try(:root))?'current':nil)) << "</li>\n"
		end.join()
		out << "</ul><!-- id='GlobalNav' -->\n"
	end

	#	NO SINGLE QUOTES OR CARRIAGE RETURNS(\n)
	#	This output is passed through javascript
	def application_user_menu
		( logged_in? and current_user.may_edit? ) ? "<ul id=\"PrivateNav\">" << 
				"<li>"  << link_to( "Pages", pages_path ) << "</li>" << 
				"<li>"  << link_to( "Photos", photos_path ) << "</li>" << 
				"<li>"  << link_to( "Users", users_path ) << "</li>" << 
				"<li>"  << link_to( "Documents", documents_path ) << "</li>" << 
				"<li>"  << link_to( "Logout", logout_path ) << "</li>" << 
				"</ul><!-- id=PrivateNav -->" : ''
	end

end
