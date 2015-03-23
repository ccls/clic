require 'simplecov_test_helper'	#	should be first for some reason

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'test_helper_helper'

require 'factory_test_helper'
require 'orderable_test_helper'

require 'authlogic/test_case'

class ActiveSupport::TestCase
	#ActiveRecord::Migration.check_pending!	#	rails 4	#	WOW, autotest does not like this line!

	fixtures :all

	def login_as( user=nil )
		user_id = ( user.is_a?(User) ) ? user.id : user
		if !user_id.blank?
			assert_not_logged_in
			s = UserSession.create(User.find(user_id))
			assert_logged_in
		else
			assert_not_logged_in
		end
	end

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

#end
#class ActionController::TestCase

	def create_a_membership
		@membership = create_full_membership
	end

	def create_full_membership(options={})		#	different name
		m = FactoryGirl.create(:membership,{
			:approved   => true,
			:group_role => GroupRole['reader']}.merge(options))
		m.reload
		if options.has_key?(:approved) && !options[:approved]
			assert !m.approved? 
		else
			assert m.approved? 
		end
		m.user.reload
		if m.approved?
			assert m.user.approved?
		else
			assert !m.user.approved?
		end
		m
	end

	def group_roleless
		m = create_full_membership(
			:group      => @membership.group,
			:group_role => nil )
		assert_equal @membership.group, m.group
		assert_nil m.group_role_id
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def group_reader
		m = create_full_membership(
			:group => @membership.group )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def group_editor
		m = create_full_membership(
			:group      => @membership.group,
			:group_role => GroupRole['editor'] )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def group_moderator
		m = create_full_membership(
			:group      => @membership.group,
			:group_role => GroupRole['moderator'] )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def unapproved_group_moderator
		m = create_full_membership(
			:approved   => false,
			:group      => @membership.group,
			:group_role => GroupRole['moderator'] )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		assert !m.approved?
		assert !m.user.approved?
		m.user
	end

#	def group_administrator
#		m = create_full_membership(
#			:group      => @membership.group,
#			:group_role => GroupRole['administrator'] )
#		assert_not_nil m.group_role_id
#		assert_equal @membership.group, m.group
#		assert m.approved?
#		assert m.user.approved?
#		m.user
#	end
#
#	def unapproved_group_administrator
#		m = create_full_membership(
#			:approved   => false,
#			:group      => @membership.group,
#			:group_role => GroupRole['administrator'] )
#		assert_not_nil m.group_role_id
#		assert_equal @membership.group, m.group
#		assert !m.approved?
#		assert !m.user.approved?
#		m.user
#	end

#	the following "nonmembers" mean that they are "not members of @membership.group"

	def nonmember_roleless
		m = create_full_membership(
			:group_role => nil )
		assert_not_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def nonmember_reader
		m = create_full_membership()
		assert_not_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def nonmember_editor
		m = create_full_membership(
			:group_role => GroupRole['editor'] )
		assert_not_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def nonmember_moderator
		m = create_full_membership(
			:group_role => GroupRole['moderator'] )
		assert_not_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def unapproved_nonmember_moderator
		m = create_full_membership(
			:approved   => false,
			:group_role => GroupRole['moderator'] )
		assert_not_equal @membership.group, m.group
		assert !m.approved?
		assert !m.user.approved?
		m.user
	end

#	def nonmember_administrator
#		m = create_full_membership(
#			:group_role => GroupRole['administrator'] )
#		assert_not_equal @membership.group, m.group
#		assert m.approved?
#		assert m.user.approved?
#		m.user
#	end
#
#	def unapproved_nonmember_administrator
#		m = create_full_membership(
#			:approved   => false,
#			:group_role => GroupRole['administrator'] )
#		assert_not_equal @membership.group, m.group
#		assert !m.approved?
#		assert !m.user.approved?
#		m.user
#	end

	def membership_user
		@membership.user
	end

#	an active_user has no roles and has not been approved
#	so should NOT be allowed to do some things that an
#	approved_user can
	def approved_user(options={})		#	no site or group role, but approved member
		u = active_user(options)
		u.approve!
		u
	end

	def unapproved_user(options={})
		u = active_user(options)
		assert !u.approved?
		u
	end

	def no_login
		nil
	end

	class << self

		def site_administrators
			@site_administrators ||= %w( superuser administrator )
		end

		def non_site_administrators
			@non_site_administrators ||= ( all_test_roles - site_administrators )
		end

		def site_editors
			@site_editors ||= ( site_administrators + %w( editor ) )
		end

		def non_site_editors
			@non_site_editors ||= ( all_test_roles - site_editors )
		end

		def site_readers
			@site_readers ||= ( site_editors + %w( interviewer reader ) )
		end

		def non_site_readers
			@non_site_readers ||= ( all_test_roles - site_readers )
		end

		def unapproved_users
			@unapproved_users ||= %w( 
				unapproved_group_moderator 
				unapproved_nonmember_moderator
				unapproved_user )
		end

		def approved_users
			@approved_users ||= ( all_test_roles - unapproved_users )
		end

		def all_test_roles
			@all_test_roles ||= %w( superuser administrator editor
				interviewer reader approved_user unapproved_user
	 			unapproved_group_moderator 
	 			group_moderator group_editor group_reader group_roleless
	 			unapproved_nonmember_moderator nonmember_moderator
	 			nonmember_editor nonmember_reader nonmember_roleless )
		end

		def group_readers
			@group_readers ||= ( group_editors + %w( group_reader ) )
		end

		def non_group_readers
			@non_group_readers ||= ( all_test_roles - group_readers )
		end

		def group_editors
			@group_editors ||= ( group_moderators + %w( group_editor ) )
		end

		def non_group_editors
			@non_group_editors ||= ( all_test_roles - group_editors )
		end

		def group_moderators
			@group_moderators ||= ( site_administrators + %w( group_moderator ) )
		end

		def non_group_moderators
			@non_group_moderators ||= ( all_test_roles - group_moderators )
		end

		def group_members
			@group_members ||= %w( group_moderator group_editor group_reader )
		end

		def non_group_members
			@non_group_members ||= ( all_test_roles - group_members )
		end

	end

end
class ActionController::TestCase

	setup :activate_authlogic

end
