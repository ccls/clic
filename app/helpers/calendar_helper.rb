module CalendarHelper

	def calendar
		stylesheets('calendar')
		javascripts('calendar')
		today = Date.today	#	TODO this will be the server's today, not necessarily the user's
		calday = calendar_start_day()	
		out =  "<div>"
		out << cal_title_bar
		out << "<table id='calendar'><thead>"
		out << cal_day_names
		out << "</thead><tbody>"
		this_month = nil	#	prepare to remember
		begin
			out << "<tr>"
			7.times.each do |day|
				classes = []
				classes.push('today') if(today == calday)
				todays_announcements = @announcements.select{|e|
					e.begins_on == calday ||
					e.ends_on == calday || (
						!e.begins_on.nil? && !e.ends_on.nil? && 
						( e.begins_on .. e.ends_on ).to_a.include?(calday)
					)
				}
				classes.push('has_announcement') unless ( todays_announcements.empty? )
				out << "<td class='#{classes.join(' ')}'>#{calday.day}"
				unless ( todays_announcements.empty? )
					out << "<div class='announcements'>"
					out << todays_announcements.collect{|e|
						eout  = "<div class='announcement'>"
						eout << if e.group
								link_to(e,group_announcement_path(e.group,e))
							else
								link_to(e,announcement_path(e))
							end
						eout << "</div>"
					}.join()
					out << "</div>"
				end
				out << "</td>"
				calday = calday.next
			end
			prev_month = this_month
			this_month = calday.month
			out << "</tr>"
		#	prev_month will be nil on first loop
		#	this_month and prev_month will change on last week
		end while( prev_month.nil? || this_month == prev_month )
		out << "</tbody></table></div>"
	end

	def calendar_start_day(options={})
#	beginning_of_week will give the Monday before the given day
#		which is NOT what I want
#		calendar_month.beginning_of_week - 1.day
		#	returns Sunday before given month and year
		calendar_month - calendar_month.wday
	end

	#	returns the first day of the month
	def calendar_month
		#	Date.parse() returns => Mon, 01 Jan -4712 which we don't want
		Date.parse(params[:month]||'').beginning_of_month
	rescue
		Date.today.beginning_of_month
	end

	def cal_title_bar
		"<div class='cal_title_bar'>" <<
			link_to('&laquo; Prev', params.merge(
				:month => calendar_month.prev_month), :class => 'prev' ) <<
			"<span class='cal_title'>" <<
				"#{Date::MONTHNAMES[calendar_month.month]} #{calendar_month.year} Calendar</span>" <<
			link_to('Next &raquo;', params.merge(
				:month => calendar_month.next_month), :class => 'next' ) <<
		"</div>"
	end

	def cal_day_names
		names = Date::ABBR_DAYNAMES.collect do |wday|
			"<th>#{wday}</th>"
		end
		"<tr>#{names.join()}</tr>"
	end

end
