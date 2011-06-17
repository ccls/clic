module ApplicationHelper

	def application_root_menu
#		load 'page.rb' if Rails.env == 'development'
		load 'page.rb' unless defined?(Page);
		out = "<ul id='GlobalNav'>\n"
		out << Page.roots.collect do |page|
			"<li>" << link_to( page.menu(session[:locale]), 
				ActionController::Base.relative_url_root.to_s + page.path,
				:id => "menu_#{dom_id(page)}",
				:class => ((page == @page.try(:root)) ? 'current' : nil)) << "</li>\n"
		end.join()
		out << "<li>#{link_to( "Members Only", members_only_path )}</li>\n"
		out << "</ul><!-- id='GlobalNav' -->\n"
	end

	#	NO SINGLE QUOTES OR CARRIAGE RETURNS(\n)
	#	This output is passed through javascript
	def application_user_menu
		if logged_in?
			menu = "<ul id=\"PrivateNav\">" 
			menu << (( current_user.may_edit? ) ? "" <<
				"<li>#{link_to( "Pages", pages_path )}</li>" << 
				"<li>#{link_to( "Photos", photos_path )}</li>" << 
				"<li>#{link_to( "Users", users_path )}</li>" << 
				"<li>#{link_to( "Documents", documents_path )}</li>" : '' )
			menu << (( current_user.may_administrate? ) ? "" <<
				"<li>#{link_to( "Memberships", memberships_path )}</li>" << 
				"<li>#{link_to( "Publication Subjects (temp)", publication_subjects_path )}</li>" << 
				"<li>#{link_to( "Publications (temp)", publications_path )}</li>" << 
				"<li>#{link_to( "Doc Forms (temp)", doc_forms_path )}</li>" << 
				"<li>#{link_to( "Annual Meetings (temp)", annual_meetings_path )}</li>" << 
				"<li>#{link_to( "Studies (temp)", studies_path )}</li>" << 
				"<li>#{link_to( "Groups (temp)", groups_path )}</li>" << 
				"<li>#{link_to( "Group Roles (temp)", group_roles_path )}</li>" : '')
			menu << "<li>#{link_to( "My Account", user_path(current_user) )}</li>" <<
				"<li>#{link_to( "Logout", logout_path )}</li>" <<
				"</ul><!-- id=PrivateNav -->"
			menu
#	This isn't ever called if not logged in
#		else
#			''
		end
	end

	def members_only_menu
#		load 'group.rb' if Rails.env == 'development'
		load 'group.rb' unless defined?(Group);
		out = "<ul id='GlobalNav'>\n"
		out << "<li>#{link_to( "Home", root_path )}</li>\n"
		out << "<li>#{link_to( "Members Only", members_only_path )}</li>\n"
		out << Group.roots.collect do |group|
			if group.groups_count > 0
				children = "<li><a class='submenu_toggle'>#{group.name}</a>" <<
					"<span class='ui-icon ui-icon-triangle-1-e'>&nbsp;</span></li>\n"
#	IE8 does not like single tagged spans
#					"<span class='ui-icon ui-icon-triangle-1-e'/></li>\n"
				children << "<li class='submenu'><ul>\n"
				children << group.children.collect do |child|
					"<li>#{link_to(child.name,child)}</li>\n"
				end.join()
				children << "</ul></li>"
			else
				"<li>#{link_to(group.name,group)}</li>\n"
			end
		end.join()
		out << "<li>Inventory</li>\n"
		out << "<li>Documents and Forms</li>\n"
		out << "<li>Publications</li>\n"
		out << "<li>Member Directory</li>\n"
		out << "<li>Study Contact Info</li>\n"
		out << "</ul><!-- id='GlobalNav' -->\n"
	end

	#	Just a simple method to wrap the passed text in a span
	#	with class='required'
	def required(text)
		"<span class='required'>#{text}</span>"
	end

end
