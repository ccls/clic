module ApplicationHelper

	def application_menu
#		require_dependency 'page.rb' unless Page
		out = "<ul id='application_menu'>\n"
		if logged_in?
			out << "<li><a class='submenu_toggle'>Public Pages</a>" <<
				"<span class='ui-icon ui-icon-triangle-1-e'>&nbsp;</span></li>\n"
			style = ( @page ) ? " style='display:list-item'" : nil
			out << "<li class='submenu'#{style}><ul>\n"
			out << public_pages
			out << "</ul></li>"
			
			out << "<li class='members#{current_controller('members_onlies')}'>" <<
				"#{link_to( "Members Only Home", members_only_path )}</li>\n"
			out << group_pages
			out << "<li class='members#{current_controller('annual_meetings')}'>" <<
				"#{link_to( "Annual Meetings", annual_meetings_path )}</li>\n"
			out << "<li class='members#{current_controller('doc_forms')}'>" <<
				"#{link_to( "Documents and Forms", doc_forms_path )}</li>\n"
			out << "<li class='members#{current_controller('publications')}'>" <<
				"#{link_to( "Publications", publications_path )}</li>\n"
			out << "<li class='members#{current_controller('directories')}'>" <<
				"#{link_to( "Member Directory", directory_path )}</li>\n"
			out << "<li class='members#{current_controller('contacts')}'>" <<
				"#{link_to( "Study Contact Info", contacts_path )}</li>\n"
#			out << "<li class='inventory#{current_controller('inventories')}'>" <<
#				"#{link_to( "Inventory", inventory_path )}</li>\n"

			out << (( current_user.may_edit? ) ? "" <<
				"<li class='user'>#{link_to( "Pages", pages_path )}</li>" << 
				"<li class='user'>#{link_to( "Photos", photos_path )}</li>" << 
				"<li class='user'>#{link_to( "Users", users_path )}</li>" << 
				"<li class='user'>#{link_to( "Documents", documents_path )}</li>" : '' )

			out << (( current_user.may_administrate? ) ? "" <<
				"<li class='user'>#{link_to( "Memberships", memberships_path )}</li>" << 
				"<li class='user'>#{link_to( "Questionnaires", questionnaires_path )}</li>" << 
				"<li class='user#{current_controller('professions')}'>#{link_to( "Professions", professions_path )}</li>" << 
				"<li class='user#{current_controller('publication_subjects')}'>#{link_to( "Publication Subjects", publication_subjects_path )}</li>" << 
				"<li class='user'>#{link_to( "Studies", studies_path )}</li>" << 
				"<li class='user'>#{link_to( "Groups", groups_path )}</li>" << 
				"<li class='user'>#{link_to( "Group Roles", group_roles_path )}</li>" : '')

			out << "<li class='user'>#{link_to( "My Account", user_path(current_user) )}</li>"
			out << "<li class='user'>#{link_to( "Logout", logout_path )}</li>"
		else
			out << public_pages
			out << "<li>#{link_to( "Members Only Login", login_path )}</li>\n"
		end
		out << "</ul><!-- id='application_menu' -->\n"
		out.html_safe
	end

	def current_controller(name)
		(controller.controller_name == name) ? ' current' : nil
	end

	def public_pages
		page_menu = Page.roots.collect do |page|
			if( !page.children.empty? and ( (page == @page ) or (page == @page.try(:root)) ) )
				out = public_page_li(page)
				out << "<li><ul>"
				child_menu = page.children.collect do |child|
					public_page_li(child)
				end
				out << child_menu.join() << "</ul></li>"
			else
				public_page_li(page)
			end
		end
		page_menu.join().html_safe
	end

	def public_page_li(page)
		current = (page == @page) ? " class='current'" : nil
#		"<li#{current}>" << link_to( page.menu(session[:locale]), 
#			ActionController::Base.relative_url_root.to_s + page.path,
#			:id => "menu_#{dom_id(page)}" ) << "</li>\n"
		"<li#{current}>" << link_to( page.menu(session[:locale]), page.path,
			:id => "menu_#{dom_id(page)}" ) << "</li>\n"
	end

	def group_pages
#		require_dependency 'group.rb' unless Group
		group_menu = Group.roots.collect do |group|
			if group.groups_count > 0
				style, icon = if( group == @group.try(:parent) )
					[" style='display:list-item;'", "ui-icon-triangle-1-s"]
				else
					[                          nil, "ui-icon-triangle-1-e"]
				end
				children = "<li class='members'><a class='submenu_toggle'>#{group.name}</a>" <<
					"<span class='ui-icon #{icon}'>&nbsp;</span></li>\n"
				children << "<li class='members submenu'#{style}><ul>\n"
				children << group.children.collect do |child|
					group_li(child)
				end.join()
				children << "</ul></li>"
			else
				group_li(group)
			end
		end
		group_menu.join().html_safe
	end

	def group_li(group)
		current = ( group == @group ) ? ' current' : nil
		"<li class='members#{current}'>#{link_to(group.name,group)}</li>\n".html_safe
	end

	#	&uarr; and &darr;
	def sort_link(column,text=nil)
		order = column.to_s.downcase.gsub(/\s+/,'_')
		dir = ( params[:dir] && params[:dir] == 'asc' ) ? 'desc' : 'asc'
		link_text = text||column
		classes = []	#[order]
		arrow = ''
		if params[:order] && params[:order] == order
			classes.push('sorted')
			arrow = if dir == 'desc'
				"<span class='down arrow'>&darr;</span>"
			else
				"<span class='up arrow'>&uarr;</span>"
			end
		end
		s = "<div class='#{classes.join(' ')}'>"
		s << link_to(link_text,params.merge(:order => order,:dir => dir))
		s << arrow unless arrow.blank?
		s << "</div>"
		s.html_safe
	end

	def user_roles
		s = ''
		if current_user.may_administrate?
			s << "<ul>"
			@roles.each do |role|
				s << "<li>"
				if @user.role_names.include?(role.name)
#	TODO rails 3 does some new stuff for links with methods?
#	data-method, etc.
#					s << link_to( "Remove user role of '#{role.name}'", 
					s << button_to( "Remove user role of '#{role.name}'", 
						user_role_path(@user,role.name),
						:method => :delete )
				else
#	TODO rails 3 does some new stuff for links with methods?
#	data-method, etc.
#					s << link_to( "Assign user role of '#{role.name}'", 
					s << button_to( "Assign user role of '#{role.name}'", 
						user_role_path(@user,role.name),
						:method => :put )
				end
				s << "</li>\n"
			end
			s << "</ul>\n"
		end
		s.html_safe
	end

end
