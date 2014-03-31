require 'integration_test_helper'

class CapybaraIntegrationTest < ActionDispatch::CapybaraIntegrationTest

#	This test file is simply used to develop tests as autotest
#	does not load new files, only those that already exist.
#	Once working, I would put them in their own file.

	all_test_roles.each do |cu|

		test "should login with #{cu} login" do
			u = send(cu)
			login_as u
		end

		test "should logout with #{cu} login" do
			u = send(cu)
			login_as u
			visit root_path
			assert_equal current_path, root_path
			assert has_css?('#menu #application_menu')
			assert has_link?('Logout')
			click_link('Logout')
			assert_equal current_path, root_path
			assert has_no_link?('Logout')
		end

	end

end
