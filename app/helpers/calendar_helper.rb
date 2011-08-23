module CalendarHelper

	def calendar
		stylesheets('calendar')
		javascripts('calendar')
		today = Date.today	#	TODO this will be the server's today, not necessarily the user's
		calday = calendar_start_day()		#	TODO insert some params for flipping through the calendar
		out = "<table id='calendar'><thead><tr>"
		out << Date::ABBR_DAYNAMES.collect do |wday|
			"<th>#{wday}</th>"
		end.join()
		out << "</tr></thead><tbody>"
		this_month = nil	#	prepare to remember
		begin
			out << "<tr>"
			7.times.each do |day|
				classes = []
				classes.push('today') if(today == calday)
				todays_events = @events.select{|e|
					e.begins_on == calday ||
					e.ends_on == calday || (
						!e.begins_on.nil? && !e.ends_on.nil? && 
						( e.begins_on .. e.ends_on ).to_a.include?(calday)
					)
				}
				classes.push('has_event') unless ( todays_events.empty? )
				out << "<td class='#{classes.join(' ')}'>#{calday.day}"
				unless ( todays_events.empty? )
					out << "<div class='events'>"
					out << todays_events.collect{|e|
						eout  = "<div class='event'>"
						eout << link_to(e,event_path(e))
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
		out << "</tbody></table>"
	end

	def calendar_start_day(options={})
#	returns Sunday before given month and year
		# start calendar on the Sunday before the first Saturday which may be last month
		(Chronic.parse('Sunday this month') - 7.days ).to_date
	end

end
