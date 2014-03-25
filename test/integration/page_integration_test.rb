require 'integration_test_helper'

class PageIntegrationTest < ActionDispatch::CapybaraIntegrationTest

	site_editors.each do |cu|

		test "should get new page with tinymce loaded and #{cu} login" do
			login_as send(cu)
			visit new_page_path
			assert has_css?("#page div.fields div.mce-tinymce div.mce-edit-area")
		end

#		test "should create new page with #{cu} login" do
#			login_as send(cu)
#			visit new_page_path
#			fill_in "page[path]",     :with => "/MyNewPath"
#			fill_in "page[menu_en]",  :with => "MyNewMenu"
#			fill_in "page[title_en]", :with => "MyNewTitle"
#			fill_in "page[body_en]",  :with => "MyNewBody"
#
#			assert_difference('Page.count',1) {
#				click_button "Create"	
#				wait_until { has_css?("p.flash.notice") }
#			}
#
#			assert has_css?("p.flash.notice")	#	success
#			assert_match /\/pages\/\d+/, current_path
#		end
#
#		test "should edit a page with #{cu} login" do
#			assert Page.count > 0
#			p = Page.first	#	DO NOT USE 'page' as it is part of capybara
#			login_as send(cu)
#			visit edit_page_path(p)
#			assert_equal edit_page_path(p), current_path
#		end
#
#		test "should edit and update a page with #{cu} login" do
#			assert Page.count > 0
#			p = Page.first	#	DO NOT USE 'page' as it is part of capybara
#			login_as send(cu)
#			visit edit_page_path(p)
#			fill_in "page[menu_en]", :with => "MyNewMenu"
#			click_button "Update"	
#			assert has_css?("p.flash.notice")
#			assert_equal current_path, page_path(p)
#		end

	end

end
