ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'group_test_helper'

class ActiveSupport::TestCase

	fixtures :all

	def login_as( user=nil )
		user_id = ( user.is_a?(User) ) ? user.id : user
		if !user_id.blank?
			assert_not_logged_in
			UserSession.create(User.find(user_id))
			assert_logged_in
		end
	end
	alias :login  :login_as
	alias :log_in :login_as

	def assert_redirected_to_login
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	def assert_redirected_to_logout
		assert_redirected_to logout_path
	end

	def assert_logged_in
		assert_not_nil UserSession.find
	end

	def assert_not_logged_in
		assert_nil UserSession.find
	end

	def self.assert_should_create_default_object
		#       It appears that model_name is a defined class method already in ...
		#       activesupport-####/lib/active_support/core_ext/module/model_naming.rb
		test "should create default #{model_name.sub(/Test$/,'').underscore}" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_object
				assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			end
		end
	end

end

require 'authlogic/test_case'
class ActionController::TestCase
	setup :turn_https_on
#	include Authlogic::TestCase
	setup :activate_authlogic

	def create_a_membership
		@membership = create_membership
	end

	def create_membership(options={})
		Factory(:membership,{
			:group_role => GroupRole['reader']}.merge(options))
	end

	def group_roleless
		m = create_membership(
			:group => @membership.group,
			:group_role => nil )
		assert_equal @membership.group, m.group
		assert_nil m.group_role_id
		m.user
	end

	def group_reader
		m = create_membership(
			:group => @membership.group )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		m.user
	end

	def group_editor
		m = create_membership(
			:group => @membership.group,
			:group_role => GroupRole['editor'] )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		m.user
	end

	def group_moderator
		m = create_membership(
			:group => @membership.group,
			:group_role => GroupRole['moderator'] )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		m.user
	end

	def group_administrator
		m = create_membership(
			:group => @membership.group,
			:group_role => GroupRole['administrator'] )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		m.user
	end

	def nonmember_roleless
		m = create_membership(
			:group_role => nil )
		assert_not_equal @membership.group, m.group
		m.user
	end

	def nonmember_reader
		m = create_membership()
		assert_not_equal @membership.group, m.group
		m.user
	end

	def nonmember_editor
		m = create_membership(
			:group_role => GroupRole['editor'] )
		assert_not_equal @membership.group, m.group
		m.user
	end

	def nonmember_moderator
		m = create_membership(
			:group_role => GroupRole['moderator'] )
		assert_not_equal @membership.group, m.group
		m.user
	end

	def nonmember_administrator
		m = create_membership(
			:group_role => GroupRole['administrator'] )
		assert_not_equal @membership.group, m.group
		m.user
	end

	def membership_user
		@membership.user
	end

end
