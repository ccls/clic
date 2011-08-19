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
		assert_select response, "ul#application_menu" do
			assert_select "li", 10
		end
	end

	test "application_menu should not include user section when not logged in" do
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.user", 0
		end
	end

	test "application_menu should not include members section when not logged in" do
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.members", 0
		end
	end

	test "application_menu should not include inventory section when not logged in" do
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.inventory", 0
		end
	end

	test "should return application_menu when logged in" do
		login_as send(:reader)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li", 19
		end
	end

	test "application_menu should include user section when logged in" do
		login_as send(:reader)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.user", 2
		end
	end

	test "application_menu should include members section when logged in" do
		login_as send(:reader)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.members", 14
		end
	end

	test "application_menu should include inventory section when logged in" do
		login_as send(:reader)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.inventory", 1
		end
	end

	test "application_menu should include larger user section when logged in as editor" do
		login_as send(:editor)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.user", 6
		end
	end

	test "application_menu should include even larger user section when logged in as administrator" do
		login_as send(:administrator)
		response = HTML::Document.new(application_menu).root
		assert_select response, "ul#application_menu" do
			assert_select "li.user", 11
		end
	end
	
#	def required(text)

	test "should respond_to required" do
		assert respond_to?(:required)
	end
	
	test "required(text) should" do
		response = HTML::Document.new(required('something')).root
		#"<span class='required'>something</span>"
		assert_select response, 'span.required', 'something', 1
	end

private 
#	"fake" controller methods
	def params
		@params || {}
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
