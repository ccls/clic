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
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
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
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 0
		end
	end

	test "application_menu should not include members section when not logged in" do
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
		assert_select response, "ul#application_menu" do
			assert_select "li.members", :count => 0
		end
	end

	test "application_menu should not include inventory section when not logged in" do
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
		assert_select response, "ul#application_menu" do
			assert_select "li.inventory", :count => 0
		end
	end

	test "should return application_menu when logged in" do
		login_as send(:reader)
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
		assert_select response, "ul#application_menu" do
#			assert_select "li", 19
#	remove the Inventory link, so this'll now be 18
#puts menu
#<ul id="application_menu">
#<li>
#<a class="submenu_toggle">Public Pages</a><span class="ui-icon ui-icon-triangle-1-e"> </span>
#</li>
#<li class="submenu"><ul>
#<li><a id="menu_page_1" href="/">Home</a></li>
#<li><a id="menu_page_2" href="/about">About</a></li>
#<li><a id="menu_page_3" href="/members">Members</a></li>
#<li><a id="menu_page_4" href="/casestudies">CLIC Studies</a></li>
#<li><a id="menu_page_5" href="/researchprojects">Research Projects</a></li>
#<li><a id="menu_page_7" href="/public">Publications</a></li>
#<li><a id="menu_page_8" href="/links">Links</a></li>
#<li><a id="menu_page_9" href="/contact">Contact Us</a></li>
#</ul></li>
#<li class="members"><a href="/members_only">Members Only Home</a></li>
#<li class="members"><a href="/groups/1">Coordination Group</a></li>
#<li class="members"><a href="/groups/2">Management Group</a></li>
#<li class="members">
#<a class="submenu_toggle">Core Logistics Groups</a><span class="ui-icon ui-icon-triangle-1-e"> </span>
#</li>
#<li class="members submenu"><ul>
#<li class="members"><a href="/groups/159216743">Data Management</a></li>
#<li class="members"><a href="/groups/255552193">Disease Classification and Pathology</a></li>
#<li class="members"><a href="/groups/383973226">Methods</a></li>
#<li class="members"><a href="/groups/467750631">Ethics</a></li>
#<li class="members"><a href="/groups/833231281">Biospecimen</a></li>
#</ul></li>
#<li class="members">
#<a class="submenu_toggle">Interest Groups</a><span class="ui-icon ui-icon-triangle-1-e"> </span>
#</li>
#<li class="members submenu"><ul>
#<li class="members"><a href="/groups/49839441">Occupational Exposures</a></li>
#<li class="members"><a href="/groups/58051802">Infant Leukemia</a></li>
#<li class="members"><a href="/groups/103210531">Environmental Exposure</a></li>
#<li class="members"><a href="/groups/314760547">Genetic Studies</a></li>
#<li class="members"><a href="/groups/374441761">Infection and Immunity</a></li>
#<li class="members"><a href="/groups/422154922">AML and APL</a></li>
#<li class="members"><a href="/groups/635838813">Family History</a></li>
#<li class="members"><a href="/groups/777310459">Outcomes</a></li>
#<li class="members"><a href="/groups/1018266143">Birth Characteristics</a></li>
#</ul></li>
#<li class="members">
#<a class="submenu_toggle">Working Groups</a><span class="ui-icon ui-icon-triangle-1-e"> </span>
#</li>
#<li class="members submenu"><ul>
#<li class="members"><a href="/groups/146093445">MTHFR Pooling</a></li>
#<li class="members"><a href="/groups/405694412">Birth Characteristics Pooling</a></li>
#</ul></li>
#<li class="members"><a href="/annual_meetings">Annual Meetings</a></li>
#<li class="members"><a href="/doc_forms">Documents and Forms</a></li>
#<li class="members"><a href="/publications">Publications</a></li>
#<li class="members"><a href="/directory">Member Directory</a></li>
#<li class="members"><a href="/contacts">Study Contact Info</a></li>
#<li class="user"><a href="/users/930">My Account</a></li>
#<li class="user"><a href="/logout">Logout</a></li>
#</ul>
#	not really sure where 18 or 19 came from.  I count 42. different assert_select
			assert_select "li", :count => 42
		end
	end

	test "application_menu should include user section when logged in" do
		login_as send(:reader)
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 2
		end
	end

	test "application_menu should include members section when logged in" do
		login_as send(:reader)
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
		assert_select response, "ul#application_menu" do

#	@selected is the internal value of that matched by assert_select
#puts @selected
#	it uses @selected like I would if I took the value from the block like |selected|
#	and then called "assert_select selected, ....."
#	So nesting does work.  I don't think that it used to.

#<ul id="application_menu">
#<li>
#<a class="submenu_toggle">Public Pages</a><span class="ui-icon ui-icon-triangle-1-e"> </span>
#</li>
#<li class="submenu"><ul>
#<li><a id="menu_page_1" href="/">Home</a></li>
#<li><a id="menu_page_2" href="/about">About</a></li>
#<li><a id="menu_page_3" href="/members">Members</a></li>
#<li><a id="menu_page_4" href="/casestudies">CLIC Studies</a></li>
#<li><a id="menu_page_5" href="/researchprojects">Research Projects</a></li>
#<li><a id="menu_page_7" href="/public">Publications</a></li>
#<li><a id="menu_page_8" href="/links">Links</a></li>
#<li><a id="menu_page_9" href="/contact">Contact Us</a></li>
#</ul></li>
#<li class="members"><a href="/members_only">Members Only Home</a></li>
#<li class="members"><a href="/groups/1">Coordination Group</a></li>
#<li class="members"><a href="/groups/2">Management Group</a></li>
#<li class="members">
#<a class="submenu_toggle">Core Logistics Groups</a><span class="ui-icon ui-icon-triangle-1-e"> </span>
#</li>
#<li class="members submenu"><ul>
#<li class="members"><a href="/groups/159216743">Data Management</a></li>
#<li class="members"><a href="/groups/255552193">Disease Classification and Pathology</a></li>
#<li class="members"><a href="/groups/383973226">Methods</a></li>
#<li class="members"><a href="/groups/467750631">Ethics</a></li>
#<li class="members"><a href="/groups/833231281">Biospecimen</a></li>
#</ul></li>
#<li class="members">
#<a class="submenu_toggle">Interest Groups</a><span class="ui-icon ui-icon-triangle-1-e"> </span>
#</li>
#<li class="members submenu"><ul>
#<li class="members"><a href="/groups/49839441">Occupational Exposures</a></li>
#<li class="members"><a href="/groups/58051802">Infant Leukemia</a></li>
#<li class="members"><a href="/groups/103210531">Environmental Exposure</a></li>
#<li class="members"><a href="/groups/314760547">Genetic Studies</a></li>
#<li class="members"><a href="/groups/374441761">Infection and Immunity</a></li>
#<li class="members"><a href="/groups/422154922">AML and APL</a></li>
#<li class="members"><a href="/groups/635838813">Family History</a></li>
#<li class="members"><a href="/groups/777310459">Outcomes</a></li>
#<li class="members"><a href="/groups/1018266143">Birth Characteristics</a></li>
#</ul></li>
#<li class="members">
#<a class="submenu_toggle">Working Groups</a><span class="ui-icon ui-icon-triangle-1-e"> </span>
#</li>
#<li class="members submenu"><ul>
#<li class="members"><a href="/groups/146093445">MTHFR Pooling</a></li>
#<li class="members"><a href="/groups/405694412">Birth Characteristics Pooling</a></li>
#</ul></li>
#<li class="members"><a href="/annual_meetings">Annual Meetings</a></li>
#<li class="members"><a href="/doc_forms">Documents and Forms</a></li>
#<li class="members"><a href="/publications">Publications</a></li>
#<li class="members"><a href="/directory">Member Directory</a></li>
#<li class="members"><a href="/contacts">Study Contact Info</a></li>
#<li class="user"><a href="/users/970">My Account</a></li>
#<li class="user"><a href="/logout">Logout</a></li>
#</ul>
#	again, not sure where 14 came from.  I see 30. non-nested?
			assert_select "li.members", :count => 30
		end
	end

	test "application_menu should include inventory section when logged in" do
		login_as send(:reader)
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
		assert_select response, "ul#application_menu" do
#			assert_select "li.inventory", 1
#	remove the Inventory link, so this'll now be 0
			assert_select "li.inventory", :count => 0
		end
	end

	test "application_menu should include larger user section when logged in as editor" do
		login_as send(:editor)
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
		assert_select response, "ul#application_menu" do
			assert_select "li.user", :count => 6
		end
	end

	test "application_menu should include even larger user section when logged in as administrator" do
		login_as send(:administrator)
		response = Nokogiri::HTML::DocumentFragment.parse(application_menu)
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
#		response = Nokogiri::HTML::DocumentFragment.parse(required('something'))
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
		response = Nokogiri::HTML::DocumentFragment.parse("<ul>#{group_pages}</ul>")
		assert_select response, 'span.ui-icon-triangle-1-e', :count => 3
	end

	test "should return group_pages with @group not as root" do
		@group = Group.not_roots.first
		response = Nokogiri::HTML::DocumentFragment.parse("<ul>#{group_pages}</ul>")
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
