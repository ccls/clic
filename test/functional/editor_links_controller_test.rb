require 'test_helper'

class EditorLinksControllerTest < ActionController::TestCase

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
			get :index, :format => :js
			assert_response :success
			assert_template 'index'
			assert assigns(:pages)
			assert_match /var tinyMCELinkList = new Array/, @response.body
	  end

  end

end
