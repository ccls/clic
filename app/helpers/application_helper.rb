module ApplicationHelper

	def application_menu
		load 'page.rb' unless defined?(Page);
		out = "<ul id='application_menu'>\n"
		if logged_in?
			out << "<li><a class='submenu_toggle'>Public</a>" <<
				"<span class='ui-icon ui-icon-triangle-1-e'>&nbsp;</span></li>\n"
			out << "<li class='submenu'><ul>\n"
			out << Page.roots.collect do |page|
				"<li>" << link_to( page.menu(session[:locale]), 
					ActionController::Base.relative_url_root.to_s + page.path,
					:id => "menu_#{dom_id(page)}",
					:class => ((page == @page.try(:root)) ? 'current' : nil)) << "</li>\n"
			end.join()
			out << "</ul></li>"

			out << "<li class='members'>#{link_to( "Members Only Home", members_only_path )}</li>\n"
			load 'group.rb' unless defined?(Group);
			out << Group.roots.collect do |group|
				if group.groups_count > 0
					children = "<li class='members'><a class='submenu_toggle'>#{group.name}</a>" <<
						"<span class='ui-icon ui-icon-triangle-1-e'>&nbsp;</span></li>\n"
						#	IE8 does not like single tagged spans
						#	"<span class='ui-icon ui-icon-triangle-1-e'/></li>\n"
					children << "<li class='members submenu'><ul>\n"
					children << group.children.collect do |child|
						"<li class='members'>#{link_to(child.name,child)}</li>\n"
					end.join()
					children << "</ul></li>"
				else
					"<li class='members'>#{link_to(group.name,group)}</li>\n"
				end
			end.join()
			out << "<li class='members'>#{link_to( "Annual Meetings", annual_meetings_path )}</li>\n"
			out << "<li class='members'>#{link_to( "Documents and Forms", doc_forms_path )}</li>\n"
			out << "<li class='members'>#{link_to( "Publications", publications_path )}</li>\n"
			out << "<li class='members'>Member Directory TODO</li>\n"
			out << "<li class='members'>Study Contact Info TODO</li>\n"
			out << "<li class='inventory'>#{link_to( "Inventory", inventory_path )}</li>\n"

			out << (( current_user.may_edit? ) ? "" <<
				"<li class='user'>#{link_to( "Pages", pages_path )}</li>" << 
				"<li class='user'>#{link_to( "Photos", photos_path )}</li>" << 
				"<li class='user'>#{link_to( "Users", users_path )}</li>" << 
				"<li class='user'>#{link_to( "Documents", documents_path )}</li>" : '' )

			out << (( current_user.may_administrate? ) ? "" <<
				"<li class='user'>#{link_to( "Memberships", memberships_path )}</li>" << 
				"<li class='user'>#{link_to( "Publication Subjects (temp)", publication_subjects_path )}</li>" << 
				"<li class='user'>#{link_to( "Studies (temp)", studies_path )}</li>" << 
				"<li class='user'>#{link_to( "Groups (temp)", groups_path )}</li>" << 
				"<li class='user'>#{link_to( "Group Roles (temp)", group_roles_path )}</li>" : '')

			out << "<li class='user'>#{link_to( "My Account", user_path(current_user) )}</li>"
			out << "<li class='user'>#{link_to( "Logout", logout_path )}</li>"
		else
			out << Page.roots.collect do |page|
				"<li>" << link_to( page.menu(session[:locale]), 
					ActionController::Base.relative_url_root.to_s + page.path,
					:id => "menu_#{dom_id(page)}",
					:class => ((page == @page.try(:root)) ? 'current' : nil)) << "</li>\n"
			end.join()
			out << "<li>#{link_to( "Members Only", members_only_path )}</li>\n"
		end
		out << "</ul><!-- id='application_menu' -->\n"
	end

	#	Just a simple method to wrap the passed text in a span
	#	with class='required'
	def required(text)
		"<span class='required'>#{text}</span>"
	end

end
