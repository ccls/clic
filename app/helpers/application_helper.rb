module ApplicationHelper

	def application_root_menu
		s = "<ul id='GlobalNav'>\n"
		Page.roots.each do |page|
			s << "<li>" << link_to( page.menu(session[:locale]), 
				ActionController::Base.relative_url_root + page.path,
				:id => "menu_#{dom_id(page)}",
				:class => ((page == @page.try(:root))?'current':nil))
			s << "</li>\n"
		end
		s << "</ul><!-- id='GlobalNav' -->\n"
	end

	#	NO SINGLE QUOTES OR CARRIAGE RETURNS(\n)
	#	This output is passed through javascript
	def application_user_menu
		s = ''
		if logged_in? and current_user.is_editor?
 			s << "<ul id=\"PrivateNav\">"
 			s << "<li>"  << link_to( "Pages", pages_path ) << "</li>"
 			s << "<li>"  << link_to( "Photos", photos_path ) << "</li>"
 			s << "<li>"  << link_to( "Users", users_path ) << "</li>"
 			s << "<li>"  << link_to( "Documents", documents_path ) << "</li>"
 			s << "</ul><!-- id=PrivateNav -->"
		end
		s
	end

end
