require 'test_helper'

class EditorImagesControllerTest < ActionController::TestCase

	assert_no_access_without_login({ :actions => [:index] })

	assert_no_route(:get,:new)
	assert_no_route(:post,:create)
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	setup :create_a_membership

	all_test_roles.each do |cu|
	
 	 test "should return index.js with #{cu} login" do
			login_as send(cu)
			xhr :get, :index, :format => :js
			assert_response :success
			assert_template 'index'
			assert assigns(:photos)
#			assert_match /var tinyMCEImageList = new Array/, @response.body	#	rails 3 style
#puts @response.body
#Editor Images Controller should return index.js with unapproved_user login: [
#{title: "CLIC Studies", value:"/test/photos/2/original/CLICStudies_113010_studies_only_no_PI.jpg?1291673380"}
#]
			assert_match /^\[.*title.*value.*\]$/m, @response.body
	  end

  end

end
