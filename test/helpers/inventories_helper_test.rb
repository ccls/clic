require 'test_helper'

class InventoriesHelperTest < ActionView::TestCase
#
##	def facet_for(facet,options={})
#
##	TODO test with AND/OR operators
##	TODO test with exposures
#
#	test "should respond_to facet_for" do
#		assert respond_to?(:facet_for)
#	end
#
#	test "facet_for is gonna be tough to test outside of a controller" do
#pending
##		response = facet_for('something')).root
##		puts response
#	end
#	
##	def multi_select_operator_for(name)
#
#	test "should respond_to multi_select_operator_for" do
#		assert respond_to?(:multi_select_operator_for)
#	end
#
#	test "multi_select_operator_for(something) with no params should return stuff" do
#		response = multi_select_operator_for('something').to_html_document
#		assert_select response, "div" do
#			assert_select 'span', 'Multi-select operator'
#			assert_select 'input', 2
#			assert_select 'input[checked=checked]', 1
#			assert_select 'input#something_op_or', 1 do
#				assert_select "[type=radio]"
#				assert_select "[value=OR]"
#				assert_select "[checked=checked]"
#			end
#			assert_select 'input#something_op_and', 1 do
#				assert_select "[type=radio]"
#				assert_select "[value=AND]"
#				assert_select ":not([checked=checked])"
#			end
#			assert_select 'label', 2
#			assert_select 'label', 'OR', 1 do
#				assert_select "[for=something_op_or]"
#			end
#			assert_select 'label', 'AND', 1 do
#				assert_select "[for=something_op_and]"
#			end
#		end
#	end
#
#	test "multi_select_operator_for(something) with something_op=OR should check OR" do
#		self.params = HashWithIndifferentAccess.new(
#			:something_op => 'OR'
#			)
#		response = multi_select_operator_for('something').to_html_document
#		assert_select response, "div" do
#			assert_select 'input[checked=checked]', 1
#			assert_select 'input#something_op_or[checked=checked]', 1
#			assert_select 'input#something_op_and:not([checked=checked])', 1
#		end
#	end
#
#	test "multi_select_operator_for(something) with something_op=AND should check AND" do
#		self.params = HashWithIndifferentAccess.new(
#			:something_op => 'AND'
#			)
#		response = multi_select_operator_for('something').to_html_document
#		assert_select response, "div" do
#			assert_select 'input[checked=checked]', 1
#			assert_select 'input#something_op_or:not([checked=checked])', 1
#			assert_select 'input#something_op_and[checked=checked]', 1
#		end
#	end
#
#protected
##	"fake" controller methods
#	def params
#		@params || HWIA.new
#	end
#	def params=(new_params)
#		@params = new_params
#	end
##	def login_as(user)
##		@current_user = user
##	end
##	def current_user	
##		@current_user
##	end
##	def logged_in?
##		!current_user.nil?
##	end
end

__END__

	def facet_for(facet,options={})
		#	options include :multiselector, :facetcount
		s  = "<b>#{pluralize(facet.rows.length,facet.name.to_s.titleize)}</b>\n"
		s << multi_select_operator_for(facet.name) if options[:multiselector]
		s << "<ul id='#{facet.name}' class='facet_field'>\n"
		facet.rows.each do |row|
			s << "<li>"
			if options[:radio]
				s << radio_button_tag( "#{facet.name}[]", row.value,
						params[facet.name].include?(row.value),
						{ :id => "#{facet.name}_#{row.value.html_friendly}" } )
			else
				s << check_box_tag( "#{facet.name}[]", row.value, 
						params[facet.name].include?(row.value),
						{ :id => "#{facet.name}_#{row.value.html_friendly}" } )
			end
			s << "<label for='#{facet.name}_#{row.value.html_friendly}'>"
			s << "<span>#{row.value}</span>"
			s << "&nbsp;(&nbsp;#{row.count}&nbsp;)" if options[:facet_counts]
			s << "</label></li>\n"
		end
    s << "</ul>\n"
	end

