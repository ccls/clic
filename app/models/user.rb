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

#	def self.find_by_anything(login)
#		find_by_login(login) || find_by_email(login) #|| find_by_id(login)
#	end

	default_scope :order => :username

	validates_length_of :password, :minimum => 8, 
		:if => :password_changed?

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
		:if => :password_changed?


#	has_and_belongs_to_many :groups
	has_many :memberships
	has_many :groups, :through => :memberships

#	ucb_authenticated
	authorized
#	document_owner
	has_many :documents, :as => :owner

#	alias_method :may_view_calendar?, :may_read?

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

	#	FYI.  gravatar can't deal with a nil email
	gravatar :email, :rating => 'PG'

	#	gravatar.url will include & that are not encoded to &amp;
	#	which works just fine, but technically is invalid html.
	def gravatar_url
		gravatar.url.gsub(/&/,'&amp;')
	end

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

	def is_group_moderator?(group)
		memberships.find(:all,:conditions => [
			'memberships.group_id = ? AND group_roles.name IN (?)', group.id, 
			['administrator','moderator'] ],
			:joins => 'LEFT JOIN group_roles on memberships.group_role_id = group_roles.id'
			).length > 0
	end

	def is_group_member?(group)
		memberships.find(:all,:conditions => [
			'memberships.group_id = ?', group.id]
			).length > 0
	end

#	def self.confirm_email(perishable_token)
#		user = User.find_using_perishable_token(perishable_token)
#		raise ActiveRecord::RecordNotFound unless user
#		user.email_confirmed_at = Time.now
#		user.save
#		user
#	end

#	before_save :confirm_new_email_address, :if => :email_changed?
#	def confirm_new_email_address
#		if email changed, save email_was in old_email
#	reset_perishable_token?
#		and set email_confirmed_at to nil and
#		send email confirmation email
#		UserMailer.deliver_confirm_email(self)
#	end

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

	alias_method :may_create?,  :may_edit?
	alias_method :may_update?,  :may_edit?
	alias_method :may_destroy?, :may_edit?
#	alias_method :may_view?,    :may_read?

	%w(	group_roles memberships ).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_administrate?
		alias_method "may_read_#{resource}?".to_sym,    :may_administrate?
		alias_method "may_edit_#{resource}?".to_sym,    :may_administrate?
		alias_method "may_update_#{resource}?".to_sym,  :may_administrate?
		alias_method "may_destroy_#{resource}?".to_sym, :may_administrate?
	end

#
#	Memberships
#
	#	Only non-members can new/create a membership
	def may_create_membership?(group)
		!is_group_member?(group)
	end

	#	Only admins and group moderators can edit/update
	def may_update_membership?(membership)
		may_administrate? || is_group_moderator?(membership.group)
	end

	#	Only admins, group moderators and self can edit/update
	def may_read_membership?(membership)
		may_administrate? || is_group_moderator?(membership.group) || self == membership.user
	end

	#	Only admins and group moderators can read the groups memberships
	def may_read_memberships?(group)
		may_administrate? || is_group_moderator?(group)
	end

	#	Only admins and group moderators can destroy the groups memberships
	def may_destroy_membership?(membership)
		may_administrate? || is_group_moderator?(membership.group)
	end

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

	#	Only admins can read groups
	def may_read_groups?
		may_administrate?
	end

	#	Only admins and group members can read a given group
	def may_read_group?(group)
		may_administrate? || is_group_member?(group)
	end

	#	Only admins can destroy a given group
	def may_destroy_group?(group)
		may_administrate?
	end

end
