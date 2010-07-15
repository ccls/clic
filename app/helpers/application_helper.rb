module ApplicationHelper

	def application_root_menu
		#<%# Page changes outside of ActionController go unnoticed %>
		#<%# Due to the variability of the menu, we can't really cache it %>
		#<%# cache 'page_menu' do %>
		roots = Page.roots
#		count = roots.length
#		count = ( count > 0 ) ? count : 1 
#		width = ( 900 - count ) / count
#		s = "<div id='rootmenu' class='main_width'>\n"
		
		s = "<ul id='GlobalNav'>\n"
		roots.each do |page|
			s << "<li>" << link_to( page.menu(session[:locale]), 
				ActionController::Base.relative_url_root + page.path )
#				:style => "width: #{width}px",
#				:class => ((page == @page.try(:root))?'current':nil))
			s << "</li>\n"
		end
		s << "</ul><!-- id='GlobalNav' -->\n"
	end

	def application_sub_menu
		if @page && !@page.root.children.empty?
			s = "<div id='submenu' class='main_width'>\n"
			s << "<div id='current_root'>"
			s << @page.root.menu(session[:locale])
			s << "</div>\n"
			s << "<div id='children'>\n"
			@page.root.children.each do |child|
				s << "<span class='child#{(@page==child)?" current_child":""}'>"
				s << link_to( child.menu(session[:locale]), 
					ActionController::Base.relative_url_root + child.path )
				s << "</span>\n"
			end
			s << "</div><!-- id='children'  -->\n"
			s << "</div><!-- id='submenu'  -->\n"
		end
	end

#	#	This creates a button that looks like a submit button
#	#	but is just a javascript controlled link.
#	#	I don't like it.
#	def button_link_to( title, url, options={} )
##		id = "id='#{options[:id]}'" unless options[:id].blank?
##		klass = if options[:class].blank?
##			"class='link'"
##		else
##			"class='#{options[:class]}'"
##		end
##		s =  "<button #{id} #{klass} type='button'>"
#		classes = ['link']
#		classes << options[:class]
#		s =  "<button class='#{classes.flatten.join(' ')}' type='button'>"
#		s << "<span class='href' style='display:none;'>"
#		s << url_for(url)
#		s << "</span>"
#		s << title
#		s << "</button>"
#		s
#	end
#
#	#	Created this to create form styled buttons to use
#	#	for the common 'cancel' feature. Unfortunately, it is
#	#	invalid HTML to have a form inside of a form.  So
#	#	this isn't as useful as initially hoped.
#	def form_link_to( title, url, options={} )
#		s =  "<form class='link_to' action='#{url}' method='get'>"
#		s << submit_tag(title, :name => nil )
#		s << "</form>"
#	end
#
#	def se_check_boxes(se,attr)
#		s = "<li>#{attr.to_s.capitalize}?<ul><li>\n"
#		s << check_box_tag( "projects[#{se.id}][#{attr}][]", 'true',
#				params.dig('projects',se.id.to_s,attr.to_s).true?,
#				:id => "projects_#{se.id}_#{attr}_true" )
#		s << label_tag( "projects_#{se.id}_#{attr}_true", "True" )
#		s << "</li><li>\n"
#		s << check_box_tag( "projects[#{se.id}][#{attr}][]", 'false',
#				params.dig('projects',se.id.to_s,attr.to_s).false?,
#				:id => "projects_#{se.id}_#{attr}_false" )
#		s << label_tag( "projects_#{se.id}_#{attr}_false", "False" )
#		s << "</li></ul></li>\n"
#	end

	def footer_menu
		s = "<div class='main_width'><p>\n"
		l = []
		l.push(link_to( 'Pages', pages_path ))
		l.push(link_to( 'Calendar', calendar_path ))
		l.push(link_to( 'Users', users_path ))
		if logged_in? 
			l.push(link_to( "My Account", user_path(current_user) ))
			l.push(link_to( "Logout", logout_path ))
		end
		s << l.join("&nbsp;|&nbsp;\n")
		s << "</p></div>\n"
	end

	def footer_sub_menu
		s = "<div class='main_width'><p>\n"
		l = ["<span>Copyright &copy; UC Regents; all rights reserved.</span>"]
		Page.hidden.each do |page|
			l.push(link_to( page.menu(session[:locale]), 
				ActionController::Base.relative_url_root + page.path ))
		end
		if session[:locale] && session[:locale] == 'es'
			l.push(link_to( 'English', locale_path('en') ))
		else
			l.push(link_to( 'Espa&ntilde;ol', locale_path('es') ))
		end
		s << l.join("&nbsp;|&nbsp;\n")
		s << "</p></div>\n"
	end

end
