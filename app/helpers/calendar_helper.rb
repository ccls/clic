module CalendarHelper

	def calendar
		stylesheets('calendar')
		javascripts('calendar')
		@today = Date.today
		# start calendar on the Sunday before the first Saturday which may be last month
		@calday = (Chronic.parse('Saturday this month') - 7.days ).to_date
		out = "<table id='calendar'><thead><tr>"
		out << Date::ABBR_DAYNAMES.collect do |wday|
			"<th>#{wday}</th>"
		end.join()
		out << "</tr></thead><tbody>"
		5.times.each do |week|
			out << "<tr>"
			7.times.each do |day|
				@calday = @calday.next
				classes = []
				classes.push('today') if(@today == @calday)
				todays_events = @events.select{|e|
					e.begins_on == @calday ||
					e.ends_on == @calday || (
						!e.begins_on.nil? && !e.ends_on.nil? && 
						( e.begins_on .. e.ends_on ).to_a.include?(@calday)
					)
				}
				classes.push('has_event') unless ( todays_events.empty? )
				out << "<td class='#{classes.join(' ')}'>#{@calday.day}"
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
			end
			out << "</tr>"
		end
		out << "</tbody></table>"
	end

end
