require 'test_helper'

class EditorImagesControllerTest < ActionController::TestCase

	assert_no_access_without_login({
		:actions => [:index]
	})

	assert_no_route(:get,:new)
	assert_no_route(:post,:create)
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	setup :create_a_membership

	ALL_TEST_ROLES.each do |cu|
	
 	 test "should return index.js with #{cu} login" do
			login_as send(cu)
			get :index, :format => :js
			assert_response :success
			assert_template 'index'
			assert assigns(:photos)
			assert_match /var tinyMCEImageList = new Array/, @response.body
	  end

  end

end