module ApplicationHelper

	def application_root_menu
		out = "<ul id='GlobalNav'>\n"
		out << Page.roots.collect do |page|
			"<li>" << link_to( page.menu(session[:locale]), 
				ActionController::Base.relative_url_root.to_s + page.path,
				:id => "menu_#{dom_id(page)}",
				:class => ((page == @page.try(:root))?'current':nil)) << "</li>\n"
		end.join()
		out << "<li>" << link_to( "Members Only", members_only_path ) << "</li>\n"
		out << "</ul><!-- id='GlobalNav' -->\n"
	end

	#	NO SINGLE QUOTES OR CARRIAGE RETURNS(\n)
	#	This output is passed through javascript
	def application_user_menu
		if logged_in?
			menu = "<ul id=\"PrivateNav\">" 
			menu << if ( current_user.may_edit? )
				"<li>"  << link_to( "Pages", pages_path ) << "</li>" << 
				"<li>"  << link_to( "Photos", photos_path ) << "</li>" << 
				"<li>"  << link_to( "Users", users_path ) << "</li>" << 
				"<li>"  << link_to( "Documents", documents_path ) << "</li>"
			end
			menu << "<li>"  << link_to( "Logout", logout_path ) << "</li>" <<
				"</ul><!-- id=PrivateNav -->"
			menu
		end
	end

end
