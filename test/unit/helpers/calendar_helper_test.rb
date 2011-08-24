require 'test_helper'

class CalendarHelperTest < ActionView::TestCase

	def setup
		self.params = HWIA.new( :controller => 'members_onlies', :action => 'show' )
		@events = []
	end

# def calendar

	test "should respond_to calendar" do
		assert respond_to?(:calendar)
	end

	test "should return calendar" do
		response = HTML::Document.new(calendar).root
		assert_select response, "div" do
			assert_select "div.cal_title_bar" do
				assert_select "a.prev", 1
				assert_select "span.cal_title", 1
				assert_select "a.next", 1
			end
			assert_select "table#calendar" do
				assert_select "td.today", 1
			end
		end
	end

	#	test with 4-week month Feb with Sunday as first
	#>> Date.parse('Feb 1 2009')
	#=> Sun, 01 Feb 2009
	test "should return 4 week calendar for Feb 1 2009" do
		self.params[:month] = '2009-02-01'
		response = HTML::Document.new(calendar).root
		assert_select response, "div" do
			assert_select "table#calendar" do
				assert_select "tbody" do
					assert_select "tr", 4
				end
			end
		end
	end

	#	test with 6-week month with first on Saturday
	#>> Date.parse('Jan 1 2000')
	#=> Sat, 01 Jan 2000
	test "should return 6 week calendar for Jan 1 2000" do
		self.params[:month] = '2000-01-01'
		response = HTML::Document.new(calendar).root
		assert_select response, "div" do
			assert_select "table#calendar" do
				assert_select "tbody" do
					assert_select "tr", 6
				end
			end
		end
	end

	test "should return calendar with an event" do
		@events << create_event(:begins_on => Date.today)
		response = HTML::Document.new(calendar).root
		assert_select response, "div" do
			assert_select "table#calendar" do
				assert_select "td.has_event", 1 do
					assert_select "div.events", 1 do
						assert_select "div.event", 1
					end
				end
			end
		end
	end

	test "should return calendar with event spanning multiple days" do
		#	this will be a bit dependent on what day the test actually runs
		#	3 day event, but only guaranteed that 2 days are this month
		@events << create_event(:begins_on => Date.yesterday,
			:ends_on => Date.tomorrow)
		response = HTML::Document.new(calendar).root
		assert_select response, "div" do
			assert_select "table#calendar" do
				assert_select "td.has_event", 2..3 do |days|
					days.each do |day|
						assert_select day, "div.events", 1 do
							assert_select "div.event", 1
						end
					end
				end
			end
		end
	end

	test "should return calendar with multiple events on single day" do
		@events << create_event(:begins_on => Date.today)
		@events << create_event(:begins_on => Date.today)
		response = HTML::Document.new(calendar).root
		assert_select response, "div" do
			assert_select "table#calendar" do
				assert_select "td.has_event", 1 do
					assert_select "div.events", 1 do
						assert_select "div.event", 2
					end
				end
			end
		end
	end

	test "should return calendar with a group event" do
		@group = create_group
		self.params = HWIA.new( :controller => 'groups', :action => 'show', :id => @group.id )
		@group.events << create_event(:begins_on => Date.today)
		@events = @group.events #	@events expected by calendar
		response = HTML::Document.new(calendar).root
		assert_select response, "div" do
			assert_select "table#calendar" do
				assert_select "td.has_event", 1 do
					assert_select "div.events", 1 do
						assert_select "div.event", 1
					end
				end
			end
		end
	end

# def calendar_start_day

	test "should respond_to calendar_start_day" do
		assert respond_to?(:calendar_start_day)
	end

	test "should return calendar_start_day date" do
		response = calendar_start_day
		assert response.is_a?(Date)
		assert_equal 0, response.wday
	end

# def calendar_month

	test "should respond_to calendar_month" do
		assert respond_to?(:calendar_month)
	end

	test "should return calendar_month date" do
		response = calendar_month
		assert response.is_a?(Date)
		assert_equal Date.today.beginning_of_month, response
	end

protected
#	"fake" controller methods
	def params
		@params || HWIA.new	#	{}
	end
	def params=(new_params)
		@params = new_params
	end
	def javascripts(*args)
		#	placeholder so can call calendar and avoid
		#		NoMethodError: undefined method `javascripts' for #<CalendarHelperTest:0x106049140>
	end
	def stylesheets(*args)
		#	placeholder so can call calendar and avoid
		#		NoMethodError: undefined method `stylesheets' for #<CalendarHelperTest:0x106049140>
	end
end
