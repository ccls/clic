class User < ActiveRecord::Base

#	TODO remove profession column from users table

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

		#	default is just 10.minutes
		c.perishable_token_valid_for = 12.hours

		#	authlogic 3.4.0 will require something like ...
		c.crypto_provider = Authlogic::CryptoProviders::Sha512
		#	due to changes.  Not sure what repercussions there are.

	end

#	the above adds some validations, some of which I'd like to remove
#		password length
#		password_confirmation length
#		password confirmation when password hasn't changed

#	def self.find_by_anything(login)
#		find_by_login(login) || find_by_email(login) #|| find_by_id(login)
#	end

	has_and_belongs_to_many :roles,  ->{ uniq },
		:after_add  => :after_add_role

	def after_add_role(role)
		approve! unless approved?
	end

	has_many :memberships
	has_many :approved_memberships, ->{ where( approved: true ) }, class_name: 'Membership'
	has_many :group_documents
	has_many :announcements
	has_many :topics
	has_many :posts
	has_many :groups, :through => :memberships
	has_many :documents, :as => :owner
	has_many :user_professions
	has_many :professions, :through => :user_professions

	def valid_password_required?
		password_changed? || !password_confirmation.blank?
	end

	validations_from_yaml_file

	before_validation :nullify_blank_avatar_file_name

	has_attached_file :avatar,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/user_avatar.yml')
		))).result)[Rails.env]

	#	to avoid the following error
	#	Paperclip::Errors::MissingRequiredValidatorError
	do_not_validate_attachment_file_type :avatar


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

	def self.search(options={})	#	rails 4
		users = User.all
		if !options[:role_name].blank?
			users = users.includes(:roles)	#	can't remember why I do this
			if Role.all.collect(&:name).include?(options[:role_name])
				users = users.joins(:roles).where('roles.name' => options[:role_name])
			end 
		end 
		users
	end

#	def self.search(options={})	#	rails 3
#		conditions = {}
#		includes = joins = []
#		if !options[:role_name].blank?
#			includes = [:roles]
#			if Role.all.collect(&:name).include?(options[:role_name])
#				joins = [:roles]
#				conditions = ["roles.name = ?",options[:role_name]]
#			end 
#		end 
#		self.all( 
#			:joins => joins, 
#			:include => includes,
#			:conditions => conditions )
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

	def to_s
		username.to_s
	end

	def approve!
		self.approved = true
		save!
		self
	end

	def approved?
		approved
	end

	def profession_names
		professions.collect(&:name).join(', ')
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching name.
	#	use matches to remove case sensitivity
	def self.[](username)
#	for some reason this doesn't show as tested in coverage (also the find_by_* methods are old)
#		find_by_username(username.to_s) #|| raise(NotFound)
		where(self.arel_table[:username].matches(username.to_s)).first
	end

	#	MUST come after simply_authorized call
#	load 'site_permissions.rb' unless defined?(SitePermissions);
#	require_dependency 'site_permissions.rb' unless SitePermissions
	include SitePermissions;
#	load 'group_permissions.rb' unless defined?(GroupPermissions);
#	require_dependency 'group_permissions.rb' unless GroupPermissions
	include GroupPermissions;

end
