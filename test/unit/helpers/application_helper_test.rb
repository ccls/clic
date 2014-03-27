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
		response = HTML::Document.new(application_menu).root
#puts response
#<ul id="application_menu">
#<li><a href="/" id="menu_page_1">Home</a></li>
#<li><a href="/about" id="menu_page_2">About</a></li>
#<li><a href="/members" id="menu_page_3">Members</a></li>
#<li><a href="/casestudies" id="menu_page_4">CLIC Studies</a></li>
#<li><a href="/researchprojects" id="menu_page_5">Research Projects</a></li>
#<li><a href="/publications" id="menu_page_7">Publications</a></li>
#<li><a href="/links" id="menu_page_8">Links</a></li>
#<li><a href="/contact" id="menu_page_9">Contact Us</a></li>
#<li><a href="/login">Members Only Login</a></li>
#</ul><!-- id='application_menu' -->
		assert_select response, "ul#application_menu" do
			assert_select "li", :count => 9
		end
	end

	test "application_menu should not include user section when not logged in" do
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 0
		end
	end

	test "application_menu should not include members section when not logged in" do
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.members", :count => 0
		end
	end

	test "application_menu should not include inventory section when not logged in" do
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.inventory", :count => 0
		end
	end

	test "should return application_menu when logged in" do
		login_as send(:reader)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
#			assert_select "li", 19
#	remove the Inventory link, so this'll now be 18
			assert_select "li", :count => 18
		end
	end

	test "application_menu should include user section when logged in" do
		login_as send(:reader)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 2
		end
	end

	test "application_menu should include members section when logged in" do
		login_as send(:reader)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.members", :count => 14
		end
	end

	test "application_menu should include inventory section when logged in" do
		login_as send(:reader)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
#			assert_select "li.inventory", 1
#	remove the Inventory link, so this'll now be 0
			assert_select "li.inventory", :count => 0
		end
	end

	test "application_menu should include larger user section when logged in as editor" do
		login_as send(:editor)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 6
		end
	end

	test "application_menu should include even larger user section when logged in as administrator" do
		login_as send(:administrator)
		response = HTML::Document.new(application_menu).root
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
#		response = HTML::Document.new(required('something')).root
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
		response = HTML::Document.new("<ul>#{group_pages}</ul>").root
		assert_select response, 'span.ui-icon-triangle-1-e', :count => 3
	end

	test "should return group_pages with @group not as root" do
		@group = Group.not_roots.first
		response = HTML::Document.new("<ul>#{group_pages}</ul>").root
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
