require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Group',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_group
	}
	def factory_attributes(options={})
		Factory.attributes_for(:group,options)
	end

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login({ 
		:logins => site_administrators })

	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :groups_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

	def self.group_creators
		@group_creators ||= site_administrators
	end
	def self.group_editors
		@group_editors ||= ( group_creators + %w( group_administrator group_moderator ) )
	end
	def self.group_readers 
		@group_readers ||= ( group_editors + %w( group_editor group_reader ) )
	end
	def self.group_browsers
		@group_browsers ||= group_creators
	end
	def self.group_destroyers
		@group_destroyers ||= group_creators
	end

	group_creators.each do |cu|

		test "should get new with #{cu} login" do
pending
		end
	
		test "should create with #{cu} login" do
pending
		end
	
		test "should NOT create new group with #{cu} login when create fails" do
			Group.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('Group.count',0) do
				post :create, :group => factory_attributes
			end
			assert assigns(:group)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end
	
		test "should NOT create new group with #{cu} login and invalid group" do
			Group.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			assert_difference('Group.count',0) do
				post :create, :group => factory_attributes
			end
			assert assigns(:group)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

	end

	( ALL_TEST_ROLES - group_creators ).each do |cu|

		test "should NOT get new with #{cu}" do
pending
		end

		test "should NOT create with #{cu} login" do
pending
		end

	end

	group_editors.each do |cu|

		test "should get edit with #{cu} login" do
pending
		end

		test "should update with #{cu} login" do
pending
		end
	
		test "should NOT update group with #{cu} login when update fails" do
#			group = create_group(:updated_at => Chronic.parse('yesterday'))
			group = @membership.group
			Group.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("Group.find(#{group.id}).updated_at") {
				put :update, :id => group.id,
					:group => factory_attributes
			}
			assert assigns(:group)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
		test "should NOT update group with #{cu} login and invalid group" do
#			group = create_group(:updated_at => Chronic.parse('yesterday'))
			group = @membership.group
			Group.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("Group.find(#{group.id}).updated_at") {
				put :update, :id => group.id,
					:group => factory_attributes
			}
			assert assigns(:group)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
	end
	( ALL_TEST_ROLES - group_editors ).each do |cu|

		test "should NOT get edit with #{cu} login" do
pending
		end

		test "should NOT update with #{cu} login" do
pending
		end

	end

	group_readers.each do |cu|

		test "should read with #{cu} login" do
pending
		end

	end
	( ALL_TEST_ROLES - group_readers ).each do |cu|

		test "should NOT read with #{cu} login" do
pending
		end

	end

	group_browsers.each do |cu|

		test "should get index with #{cu} login" do
pending
		end

	end
	( ALL_TEST_ROLES - group_browsers ).each do |cu|

		test "should NOT get index with #{cu} login" do
pending
		end

	end

	group_destroyers.each do |cu|

		test "should destroy with #{cu} login" do
pending
		end

	end
	( ALL_TEST_ROLES - group_destroyers ).each do |cu|

		test "should NOT destroy with #{cu} login" do
pending
		end

	end

end
