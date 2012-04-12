ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

#gem 'test-unit', :lib => 'test/unit', :version => '~>2'
#require 'test/unit'
#require 'test/unit/priority'
#require 'test/unit/autorunner'
#require 'test/unit/testcase'

require 'test_help'
require 'action_controller_extension'
require 'active_support_extension'
require 'factory_test_helper'
require 'group_test_helper'
require 'orderable_test_helper'
#require 'test_startup_shutdown'
#require 'test_sunspot'
#TestSunspot.setup
#	TestSunspot uses startup and shutdown, which are callbacks in test-unit 2.x
#	test-unit 2.x seems to be incompatible with ruby 1.8 and rails 2.3.12

begin
#	don't think that this works in the jruby world
	Sunspot::Rails::Server.new.start
rescue Sunspot::Server::AlreadyRunningError
end


class ActiveSupport::TestCase

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

	def self.assert_should_be_searchable
		#	This does NOT test searching, it just allows testing while searchable
		test "should be searchable" do
#			Sunspot.index!
			Sunspot.remove_all!
			assert model_name.constantize.respond_to?(:search)
			search = model_name.constantize.search
			assert search.facets.empty?
			assert search.hits.empty?
			assert search.results.empty?
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
		m = Factory(:membership,{
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
		m = create_membership(
			:group      => @membership.group,
			:group_role => nil )
		assert_equal @membership.group, m.group
		assert_nil m.group_role_id
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def group_reader
		m = create_membership(
			:group => @membership.group )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def group_editor
		m = create_membership(
			:group      => @membership.group,
			:group_role => GroupRole['editor'] )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def group_moderator
		m = create_membership(
			:group      => @membership.group,
			:group_role => GroupRole['moderator'] )
		assert_not_nil m.group_role_id
		assert_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def unapproved_group_moderator
		m = create_membership(
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
#		m = create_membership(
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
#		m = create_membership(
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
		m = create_membership(
			:group_role => nil )
		assert_not_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def nonmember_reader
		m = create_membership()
		assert_not_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def nonmember_editor
		m = create_membership(
			:group_role => GroupRole['editor'] )
		assert_not_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def nonmember_moderator
		m = create_membership(
			:group_role => GroupRole['moderator'] )
		assert_not_equal @membership.group, m.group
		assert m.approved?
		assert m.user.approved?
		m.user
	end

	def unapproved_nonmember_moderator
		m = create_membership(
			:approved   => false,
			:group_role => GroupRole['moderator'] )
		assert_not_equal @membership.group, m.group
		assert !m.approved?
		assert !m.user.approved?
		m.user
	end

#	def nonmember_administrator
#		m = create_membership(
#			:group_role => GroupRole['administrator'] )
#		assert_not_equal @membership.group, m.group
#		assert m.approved?
#		assert m.user.approved?
#		m.user
#	end
#
#	def unapproved_nonmember_administrator
#		m = create_membership(
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

	def self.site_administrators
		@site_administrators ||= %w( superuser administrator )
	end

	def self.non_site_administrators
		@non_site_administrators ||= ( all_test_roles - site_administrators )
	end

	def self.site_editors
		@site_editors ||= ( site_administrators + %w( editor ) )
	end

	def self.non_site_editors
		@non_site_editors ||= ( all_test_roles - site_editors )
	end

	def self.site_readers
		@site_readers ||= ( site_editors + %w( interviewer reader ) )
	end

	def self.non_site_readers
		@non_site_readers ||= ( all_test_roles - site_readers )
	end

	def self.unapproved_users
		@unapproved_users ||= %w( 
			unapproved_group_moderator 
			unapproved_nonmember_moderator
			unapproved_user )
	end

	def self.approved_users
		@approved_users ||= ( all_test_roles - unapproved_users )
	end

	def self.all_test_roles
		@all_test_roles ||= %w( superuser administrator editor
			interviewer reader approved_user unapproved_user
 			unapproved_group_moderator 
 			group_moderator group_editor group_reader group_roleless
 			unapproved_nonmember_moderator nonmember_moderator
 			nonmember_editor nonmember_reader nonmember_roleless )
	end

	def self.group_readers
		@group_readers ||= ( group_editors + %w( group_reader ) )
	end

	def self.non_group_readers
		@non_group_readers ||= ( all_test_roles - group_readers )
	end

	def self.group_editors
		@group_editors ||= ( group_moderators + %w( group_editor ) )
	end

	def self.non_group_editors
		@non_group_editors ||= ( all_test_roles - group_editors )
	end

	def self.group_moderators
		@group_moderators ||= ( site_administrators + %w( group_moderator ) )
	end

	def self.non_group_moderators
		@non_group_moderators ||= ( all_test_roles - group_moderators )
	end

	def self.group_members
		@group_members ||= %w( group_moderator group_editor group_reader )
	end

	def self.non_group_members
		@non_group_members ||= ( all_test_roles - group_members )
	end

end



def brand	#	for auto-generated tests
	"@@ "
end
