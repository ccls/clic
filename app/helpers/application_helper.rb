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
				"<li>"  << link_to( "Documents", documents_path ) << "</li>" << 
				"<li>"  << link_to( "Groups (temp)", groups_path ) << "</li>" << 
				"<li>"  << link_to( "Group Roles (temp)", group_roles_path ) << "</li>"
			end
			menu << "<li>"  << link_to( "My Account", user_path(current_user) ) << "</li>" <<
				"<li>"  << link_to( "Logout", logout_path ) << "</li>" <<
				"</ul><!-- id=PrivateNav -->"
			menu
		end
	end

	def members_only_menu
		load 'group.rb' if Rails.env == 'development'
		out = "<ul id='GlobalNav'>\n"
		out << Group.roots.collect do |group|
			root = "<li>#{group.name}</li>\n"
			root << if group.groups_count > 0
				children = "<li><ul>"
				children << group.children.collect do |child|
					"<li>#{child.name}</li>\n"
				end.join()
				children << "</ul></li>"
			else
				''
			end
		end.join()
		out << "</ul><!-- id='GlobalNav' -->\n"
	end

end
