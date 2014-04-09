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
			xhr :get, :index, :format => :js
			assert_response :success
			assert_template 'index'
			assert assigns(:pages)
#			assert_match /var tinyMCELinkList = new Array/, @response.body	#	rails 3 style
#Editor Links Controller should return index.js with unapproved_user login: [
#{title:"Home",value:"/"},
#{title:"About",value:"/about"},
#{title:"Members",value:"/members"},
#{title:"CLIC Studies",value:"/casestudies"},
#{title:"Research Projects",value:"/researchprojects"},
#{title:"Working Groups",value:"/workinggroups"},
#{title:"Publications",value:"/public"},
#{title:"Links",value:"/links"},
#{title:"Contact Us",value:"/contact"},
#{title:"Coordination Group",value:"/coordinationgroup"},
#{title:"Management Group",value:"/managementgroup"},
#{title:"Core Logistics Groups",value:"/corelogisticsgroups"},
#{title:"Interest Groups",value:"/interestgroups"},
#{title:"Past CLIC Meetings",value:"/pastclicmeetings"}
#]
			assert_match /^\[.*title.*value.*\]$/m, @response.body
	  end

  end

end
