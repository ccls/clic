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
	document_owner

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

	%w(	group_roles groups memberships ).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_administrate?
		alias_method "may_read_#{resource}?".to_sym,    :may_administrate?
		alias_method "may_edit_#{resource}?".to_sym,    :may_administrate?
		alias_method "may_update_#{resource}?".to_sym,  :may_administrate?
		alias_method "may_destroy_#{resource}?".to_sym, :may_administrate?
	end

end
