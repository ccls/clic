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

end
