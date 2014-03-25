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

	end

end
