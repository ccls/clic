class User < ActiveRecord::Base

	#	by default, expects a username or login attribute
	#	which I didn't have and caused a bit of a headache!
	#	Also automatically logs newly created user in
	#	behind the scenes which caused testing headaches.
	#	Set this to false to remove this "feature."
	acts_as_authentic do |c|
		#	This can be a pain in testing so disabled.
		#	Creating objects via Factory with associated users 
		#	results in them being autmatically logged in.
		c.maintain_sessions = false
	end

#	the above adds some validations, some of which I'd like to remove
#		password length
#		password_confirmation length
#		password confirmation when password hasn't changed

#	def self.find_by_anything(login)
#		find_by_login(login) || find_by_email(login) #|| find_by_id(login)
#	end

	authorized	#	adds methods include role_names

	default_scope :order => :username

	has_many :memberships
	has_many :approved_memberships, 
		:class_name => 'Membership', 
		:conditions => { :approved => true }
	has_many :announcements
	has_many :group_documents
	has_many :events
	has_many :topics
	has_many :posts
	has_many :groups, :through => :memberships
	has_many :documents, :as => :owner

#	It seems that authlogic includes a minimum length of 4
#	validates_length_of :password, :minimum => 8, 
#		:if => :password_changed?

	validates_format_of :password,
		:with => Regexp.new(
			'(?=.*[a-z])' <<
			'(?=.*[A-Z])' <<
			'(?=.*\d)' <<
			# !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
			# '(?=.*[\x21-\x2F\x3A-\x40\x5B-\x60\x7B-\x7E])' 
			#	this probably includes control chars
			'(?=.*\W)' ), 
		:message => 'requires at least one lowercase and one uppercase ' <<
			'letter, one number and one special character',
		:if => :valid_password_required?
#		:if => :password_changed?
#		:unless => :password_blank?
	def valid_password_required?
		password_changed? || !password_confirmation.blank?
	end

	validates_presence_of :title
	validates_presence_of :profession
	validates_presence_of :organization
	validates_presence_of :first_name
	validates_presence_of :last_name
	validates_presence_of :degrees
	validates_presence_of :address
	validates_presence_of :phone_number

	validates_uniqueness_of :avatar_file_name, :allow_nil => true

	before_validation :nullify_blank_avatar_file_name

	has_attached_file :avatar,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/user_avatar.yml')
		))).result)[Rails.env]

	def nullify_blank_avatar_file_name
		self.avatar_file_name = nil if avatar_file_name.blank?
	end


	attr_accessor :membership_requests
	after_create :request_group_memberships
	def request_group_memberships
		unless @membership_requests.nil?
			@membership_requests.reject{|k,v| v[:group_role_id].blank? }.each do |k,v|
				m = self.memberships.new
				m.group_id = k
				m.group_role_id = v[:group_role_id]
				m.save
			end 
		end 
	end


	def self.search(options={})
		conditions = {}
		includes = joins = []
		if !options[:role_name].blank?
			includes = [:roles]
			if Role.all.collect(&:name).include?(options[:role_name])
				joins = [:roles]
#				conditions = ["roles.name = '#{options[:role_name]}'"]
				conditions = ["roles.name = ?",options[:role_name]]
	#		else
	#			@errors = "No such role '#{options[:role_name]}'"
			end 
		end 
		self.all( 
			:joins => joins, 
			:include => includes,
			:conditions => conditions )
	end 

#	#	FYI.  gravatar can't deal with a nil email
#	gravatar :email, :rating => 'PG'
#
#	#	gravatar.url will include & that are not encoded to &amp;
#	#	which works just fine, but technically is invalid html.
#	def gravatar_url
#		gravatar.url.gsub(/&/,'&amp;')
#	end

	def email_confirmed?
#	this attribute should probably be protected to avoid user
#	manually confirming email address without access
		!email_confirmed_at.nil?
	end

	def confirm_email
		self.email_confirmed_at = Time.now
		self.save
		self
	end

	def full_name
		[first_name,last_name].join(' ')
	end

#	def group_membership_roles(group)
#		approved_memberships.select{|m| m.group_id == group.id }.collect(&:group_role).compact
#	end
#
#	def group_membership_role_names(group)
#		group_membership_roles(group).collect(&:name)
#	end
#
#	def is_group_moderator?(group)
##		memberships.find(:all,:conditions => [
##			'memberships.group_id = ? AND group_roles.name IN (?)', group.id, 
##			['administrator','moderator'] ],
##			:joins => 'LEFT JOIN group_roles on memberships.group_role_id = group_roles.id'
##			).length > 0
#		( group_membership_role_names(group) & ['administrator','moderator'] ).length > 0
#	end
#
#	def is_group_editor?(group)
#		( group_membership_role_names(group) & [
#			'administrator','moderator','editor'] ).length > 0
#	end
#
#	def is_group_reader?(group)
#		( group_membership_role_names(group) & [
#			'administrator','moderator','editor','reader'] ).length > 0
#	end
#
#	def is_group_member?(group)
##		memberships.find(:all,:conditions => [
##			'memberships.group_id = ? AND memberships.group_role_id IS NOT NULL', group.id]
##			).length > 0
##	effectively the same as is_group_reader?
#		group_membership_role_names(group).length > 0
#	end

	def to_s
		username
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching name.
	def self.[](username)
		find_by_username(username.to_s) #|| raise(NotFound)
	end


	load 'group_permissions.rb' unless defined?(GroupPermissions);
	include GroupPermissions;
	load 'user_permissions.rb' unless defined?(UserPermissions);
	include UserPermissions;

#	defined in plugin/engine ...
#
#	def may_administrate?(*args)
#		(self.role_names & ['superuser','administrator']).length > 0
#	end
#
#	def may_read?(*args)
#		(self.role_names & 
#			['superuser','administrator','editor','interviewer','reader']
#		).length > 0
#	end
#
#	def may_edit?(*args)
#		(self.role_names & 
#			['superuser','administrator','editor']
#		).length > 0
#	end
#


	#	This restriction will probably be lightened,
	#	otherwise no one will be able to view other user's profiles
#	def may_view_user?(user=nil)
#		self.is_user?(user) || self.may_administrate?
#	end
#
#	def may_edit_user?(user=nil)
#		self.is_user?(user) || self.may_administrate?
#	end


#	alias_method :may_create?,  :may_edit?
#	alias_method :may_update?,  :may_edit?
#	alias_method :may_destroy?, :may_edit?
##	alias_method :may_view?,    :may_read?

	%w(	announcements events ).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_administrate?
#		alias_method "may_read_#{resource}?".to_sym,    :may_read?
		alias_method "may_edit_#{resource}?".to_sym,    :may_administrate?
		alias_method "may_update_#{resource}?".to_sym,  :may_administrate?
		alias_method "may_destroy_#{resource}?".to_sym, :may_administrate?
		define_method("may_read_#{resource}?".to_sym) { true }	#	any user
	end

	%w(	memberships group_roles ).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_administrate?
		alias_method "may_read_#{resource}?".to_sym,    :may_administrate?
		alias_method "may_edit_#{resource}?".to_sym,    :may_administrate?
		alias_method "may_update_#{resource}?".to_sym,  :may_administrate?
		alias_method "may_destroy_#{resource}?".to_sym, :may_administrate?
	end

	def may_read_forum?(forum)
		if forum && forum.group
			may_administrate? || is_group_reader?(forum.group)
		else
			true
		end
	end

	def may_edit_forum?(forum)
		if forum && forum.group
			may_administrate? || is_group_editor?(forum.group)
		else
			may_edit?
		end
	end

#
#	Group Memberships
#
	#	Only non-members can new/create a membership
	def may_create_group_membership?(group)
		!is_group_member?(group)
	end

	#	Only admins and group moderators can edit/update
	def may_update_group_membership?(membership)
		may_administrate? || is_group_moderator?(membership.group)
	end
	alias_method :may_edit_group_membership?, :may_update_group_membership?

	#	Only admins, group members and self can edit/update
	def may_read_group_membership?(membership)
		may_administrate? || is_group_reader?(membership.group) || self == membership.user
	end

	#	Only admins and group members can read the groups memberships
	def may_read_group_memberships?(group)
		may_administrate? || is_group_reader?(group)
	end

	#	Only admins and group moderators can destroy the groups memberships
	def may_destroy_group_membership?(membership)
		may_administrate? || is_group_moderator?(membership.group)
	end

#
#	Group Documents
#

	def may_read_group_document?(document)
		if document && document.group
			may_administrate? || is_group_reader?(document.group)
		else
			true
		end
	end

#	#	Only members can new/create a group document
#	def may_create_group_documents?(group)
#		may_administrate? || is_group_reader?(group)				#	change to editor
#	end
#
#	#	Only admins and group moderators can edit/update
#	def may_update_group_documents?(group)
#		may_administrate? || is_group_reader?(group)				#	change to editor
#	end
#	alias_method :may_edit_group_documents?, :may_update_group_documents?
#
#	#	Only admins, group members can edit/update
#	def may_read_group_documents?(group)
#		may_administrate? || is_group_reader?(group)
#	end
#
#	#	Only admins and group moderators can destroy the group documents
#	def may_destroy_group_documents?(group)
#		may_administrate? || is_group_moderator?(group)
#	end


#
#	Group Events
#
	#	Only members can new/create a group event
	def may_create_group_events?(group)
		may_administrate? || is_group_editor?(group)
	end

	#	Only admins and group moderators can edit/update
	def may_update_group_events?(group)
		may_administrate? || is_group_editor?(group)
	end
	alias_method :may_edit_group_events?, :may_update_group_events?

	#	Only admins, group members can edit/update
	def may_read_group_events?(group)
		may_administrate? || is_group_reader?(group)
	end

	#	Only admins and group moderators can destroy the group events
	def may_destroy_group_events?(group)
		may_administrate? || is_group_moderator?(group)
	end

#
#	Group Announcements
#
	alias_method :may_create_group_announcements?,  :may_create_group_events?
	alias_method :may_update_group_announcements?,  :may_update_group_events?
	alias_method :may_edit_group_announcements?,    :may_edit_group_events?
	alias_method :may_read_group_announcements?,    :may_read_group_events?
	alias_method :may_destroy_group_announcements?, :may_destroy_group_events?

#
#		Groups
#
	#	Only admins can new/create groups
	def may_create_groups?
		may_administrate?
	end

	#	Only admins and group moderators can edit/update groups
	def may_update_group?(group)
		may_administrate? || is_group_moderator?(group)
	end
	alias_method :may_edit_group?, :may_update_group?

	#	Only admins can read groups
	def may_read_groups?
		may_administrate?
	end

	#	Only admins and group members can read a given group
	def may_read_group?(group)
		may_administrate? || is_group_reader?(group)
	end

	#	Only admins can destroy a given group
	def may_destroy_group?(group)
		may_administrate?
	end

end
