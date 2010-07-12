require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Page',
		:actions => [:new,:create,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:page)
	end
	def factory_attributes
		Factory.attributes_for(:page)
	end

	assert_access_with_http :show, { :actions => nil }
	assert_access_with_https :show
	assert_no_access_with_http 

	assert_access_with_login(:show,{
		:logins => [:admin,:editor]})
	assert_access_with_login(:show,{
		:logins => [:moderator,:employee,:active_user], :actions => nil})
	assert_access_without_login( :show, { :actions => nil })
	assert_no_access_with_login({ 
		:logins => [:moderator,:employee,:active_user] })
	assert_no_access_without_login

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :admin,
		:redirect => :pages_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:destroy => { :id => 0 }
	)


%w( admin editor ).each do |cu|
#
#		index/new/create/edit/update/destroy 
#			should only be visible to admins for editing
#	

	test "should get index with pages with #{cu} login" do
		3.times{ Factory(:page) }
		login_as send(cu)
		get :index
		assert_template 'index'
		assert_response :success
		assert_not_nil assigns(:pages)
		assigns(:pages).each { |page| assert_nil page.parent }
	end

	test "should get index with blank parent with #{cu} login" do
		3.times{ Factory(:page) }
		login_as send(cu)
		get :index, :parent_id => ''
		assert_template 'index'
		assert_response :success
		assert_not_nil assigns(:pages)
		assigns(:pages).each { |page| assert_nil page.parent }
	end

	test "should get index with subpages with #{cu} login" do
		parent = Factory(:page)
		3.times{ Factory(:page, :parent_id => parent.id) }
		login_as send(cu)
		get :index, :parent_id => parent.id
		assert_template 'index'
		assert_response :success
		assert_not_nil assigns(:pages)
		assigns(:pages).each do |page|
			assert_equal page.parent_id, parent.id
		end
	end

	test "should create page with parent with #{cu} login" do
		parent = Factory(:page)
		login_as send(cu)
		assert_difference('Page.count') do
			post :create, :page => Factory.attributes_for(:page,
				:parent_id => parent.id)
		end
		assert_equal parent, assigns(:page).parent
		assert_redirected_to page_path(assigns(:page))
	end

	test "should NOT create page with invalid page with #{cu} login" do
		login_as send(cu)
		assert_no_difference('Page.count') do
			post :create, :page => {}
		end
		assert_template 'new'
		assert_response :success
	end

	test "should NOT update page with invalid page with #{cu} login" do
		login_as send(cu)
		put :update, :id => Factory(:page).id, 
			:page => { :title => "a" }
		assert_not_nil flash[:error]
		assert_template 'edit'
		assert_response :success
	end

	#	I don't think that this is pertinant anymore
	test "should get index with both help and non-help pages with #{cu} login" do
		#	test css menus
		login_as send(cu)
		nonhelp_page = Factory(:page, :path => "/hello" )
		help_page = Factory(:page, :path => "/help/test" )
		get :index
		assert_response :success
		assert_template 'index'
	end

#	action: order

	test "should order pages with #{cu} login" do
		login_as send(cu)
#		pages = 3.times.collect{|i| Factory(:page) }
#	3.times.collect doesn't work on 
#> ruby --version
#ruby 1.8.6 (2008-08-11 patchlevel 287) [universal-darwin9.0]
		pages = []
		3.times{ pages.push(Factory(:page)) }
		before_page_ids = Page.all.collect(&:id)
		post :order, :pages => before_page_ids.reverse
		after_page_ids = Page.all.collect(&:id)
		assert_equal after_page_ids, before_page_ids.reverse
		assert_redirected_to pages_path
	end

	test "should order sub pages with #{cu} login" do
		login_as send(cu)
		parent = Factory(:page)
		pages = []
		3.times{ pages.push(Factory(:page,:parent_id => parent.id)) }
		assert_equal [1,2,3], pages.collect(&:position)
		before_page_ids = parent.reload.children.collect(&:id)
		post :order,:parent_id => parent.id, :pages => before_page_ids.reverse
		after_page_ids = parent.reload.children.collect(&:id)
		assert_equal after_page_ids, before_page_ids.reverse
		assert_redirected_to pages_path(:parent_id => parent.id)
	end

end

%w( employee moderator active_user ).each do |cu|

	test "should NOT order pages with #{cu} login" do
		login_as send(cu)
		pages = []
		3.times{ pages.push(Factory(:page)) }
		before_page_ids = Page.all.collect(&:id)
		post :order, :pages => before_page_ids.reverse
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should NOT order pages without login" do
		pages = []
		3.times{ pages.push(Factory(:page)) }
		before_page_ids = Page.all.collect(&:id)
		post :order, :pages => before_page_ids.reverse
		assert_redirected_to_login
	end

#
#	/pages/:id should be visible to anyone ?
#
#	as the pages controller uses the gateway filter, not being logged in currently
#	requires the addition of the line ...
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
#

	test "should NOT show page with invalid id" do
		get :show, :id => 0
		assert_not_nil flash[:error]
		assert_template 'show'
		assert_response :success
	end

	test "should NOT show page without matching path" do
		get :show, :path => "/i/do/not/exist".split('/').delete_if{|x|x.blank?}
		assert_not_nil flash[:error]
		assert_template 'show'
		assert_response :success
	end

	test "should show page by path" do
		page = Factory(:page)
		get :show, :path => page.path.split('/').delete_if{|x|x.blank?}
		assert_equal assigns(:page), page
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show page by path with slashes" do
		page = Factory(:page, :path => "/help/blogs")
		get :show, :path => page.path.split('/').delete_if{|x|x.blank?}
		assert_equal assigns(:page), page
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show HOME page with HPP" do
		hpp = Factory(:home_page_pic,
			:image_file_name => 'some_fake_file_name')
		page = Page.by_path('/')
		get :show, :id => page.id
		assert_not_nil assigns(:hpp)
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show HOME page without HPP" do
		page = Page.by_path('/')
		get :show, :id => page.id
		assert_nil assigns(:hpp)
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	#	Test all page fixtures for menus
	Page.all.each do |page|
		test "should get show for page id #{page.id}" do
			get :show, :id => page.id
			assert_response :success
			assert_template 'show'
		end
		%w( en es ).each do |locale|
			test "should get show for page id #{page.id} with locale #{locale}" do
				session[:locale] = locale
				get :show, :id => page.id
				assert_response :success
				assert_template 'show'
			end
		end
	end

end