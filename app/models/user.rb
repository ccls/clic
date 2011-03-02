class User < ActiveRecord::Base

	acts_as_authentic

	has_and_belongs_to_many :groups

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


#	this has been included above
#	ucb_authenticated

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

#	def self.inherited(subclass)
#
#		subclass.class_eval do
#			#	for some reason is nil which causes problems
#			self.default_scoping = []
#
#			#	I don't think that having this in a separate gem
#			#	is necessary anymore.  This is the only place that 
#			#	it is ever used.  I'll import the calnet_authenticated
#			#	functionality later.
##			calnet_authenticated
#			validates_presence_of   :uid
#			validates_uniqueness_of :uid
#
#			#	include the many may_*? for use in the controllers
#			authorized
#
#			alias_method :may_create?,  :may_edit?
#			alias_method :may_update?,  :may_edit?
#			alias_method :may_destroy?, :may_edit?
#
#			%w(	people races languages refusal_reasons ineligible_reasons
#					).each do |resource|
#				alias_method "may_create_#{resource}?".to_sym,  :may_administrate?
#				alias_method "may_read_#{resource}?".to_sym,    :may_administrate?
#				alias_method "may_edit_#{resource}?".to_sym,    :may_administrate?
#				alias_method "may_update_#{resource}?".to_sym,  :may_administrate?
#				alias_method "may_destroy_#{resource}?".to_sym, :may_administrate?
#			end
#		end	#	class_eval
#	end	#	inherited()



end
