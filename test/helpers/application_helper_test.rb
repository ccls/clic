require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

	def setup
#		@controller = TestController.new	#	unecessary apparently
		@request    = @controller.request	#	sets up session for access
	end

#	def application_menu

	test "should respond_to application_menu" do
		assert respond_to?(:application_menu)
	end

	test "should return application_menu when not logged in" do
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			assert_select "li", :count => 9
		end
	end

	test "application_menu should not include user section when not logged in" do
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 0
		end
	end

	test "application_menu should not include members section when not logged in" do
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			assert_select "li.members", :count => 0
		end
	end

	test "application_menu should not include inventory section when not logged in" do
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			assert_select "li.inventory", :count => 0
		end
	end

	test "should return application_menu when logged in" do
		login_as send(:reader)
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			#	rails 4.1 only matches the "exposed" li tags (18?) (not the nested ul>li)
			#	rails 4.2 matches ALL of the li tags (42?)
			#puts @selected
			#	added the "> " prefix and still works
			assert_select "> li", :count => 18
			#assert_select "li", :count => 42
		end
	end

	test "application_menu should include user section when logged in" do
		login_as send(:reader)
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 2
		end
	end

	test "application_menu should include members section when logged in" do
		login_as send(:reader)
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			#	@selected is the internal value of that matched by assert_select
			#puts @selected
			#	it uses @selected like I would if I took the value from the block like |selected|
			#	and then called "assert_select selected, ....."
			#	So nesting does work.  I don't think that it used to.
			assert_select "> li.members", :count => 14
		end
	end

	test "application_menu should include inventory section when logged in" do
		login_as send(:reader)
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			assert_select "li.inventory", :count => 0
		end
	end

	test "application_menu should include larger user section when logged in as editor" do
		login_as send(:editor)
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 6
		end
	end

	test "application_menu should include even larger user section when logged in as administrator" do
		login_as send(:administrator)
		response = application_menu.to_html_document
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 13
		end
	end
	
#
#	This is available, but has been moved to a gem so can't test here
#
#	def required(text)
#
#	test "should respond_to required" do
#		assert respond_to?(:required)
#	end
#	
#	test "required(text) should" do
#		response = required('something').to_html_document
#		#"<span class='required'>something</span>"
#		assert_select response, 'span.required', :text => 'something', :count => 1
#	end

#	def current_controller(name)

	test "should respond_to current_controller" do
		assert respond_to?(:current_controller)
	end

#	def public_pages

	test "should respond_to public_pages" do
		assert respond_to?(:public_pages)
	end

#	def public_page_li(page)

	test "should respond_to public_page_li" do
		assert respond_to?(:public_page_li)
	end

#	def group_pages

	test "should respond_to group_pages" do
		assert respond_to?(:group_pages)
	end

	test "should return group_pages with @group as root" do
		@group = Group.roots.first
		response = "<ul>#{group_pages}</ul>".to_html_document
		assert_select response, 'span.ui-icon-triangle-1-e', :count => 3
	end

	test "should return group_pages with @group not as root" do
		@group = Group.not_roots.first
		response = "<ul>#{group_pages}</ul>".to_html_document
		assert_select response, 'span.ui-icon-triangle-1-e', :count => 2
		assert_select response, 'span.ui-icon-triangle-1-s', :count => 1
	end

#	def group_li(group)

	test "should respond_to group_li" do
		assert respond_to?(:group_li)
	end

protected
#	"fake" controller methods
	def params
		@params || HWIA.new
	end
	def params=(new_params)
		@params = new_params
	end
	def login_as(user)
		@current_user = user
	end
	def current_user	
		@current_user
	end
	def logged_in?
		!current_user.nil?
	end
end
