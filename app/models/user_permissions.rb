#
#	Created primarily for clarity
#
module UserPermissions

	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
			#	may_edit? isn't defined in this module so these need class_eval'd
			#	unless I completely redefine them all here (probably best if i did)
			alias_method :may_create?,  :may_edit?
			alias_method :may_update?,  :may_edit?
			alias_method :may_destroy?, :may_edit?
		#	alias_method :may_view?,    :may_read?
		end
	end

	module InstanceMethods
#
#
#		def role_names
#			roles.collect(&:name).uniq
#		end
#
#		def deputize
#			roles << Role.find_or_create_by_name('administrator')
#		end
#
#		#	The 4 common CCLS roles are ....
#		def is_superuser?(*args)
#			self.role_names.include?('superuser')
#		end
#		alias_method :is_super_user?, :is_superuser?
#
#		def is_administrator?(*args)
#			self.role_names.include?('administrator')
#		end
#
#		def is_editor?(*args)
#			self.role_names.include?('editor')
#		end
#
#		def is_interviewer?(*args)
#			self.role_names.include?('interviewer')
#		end
#
#		def is_reader?(*args)
#			self.role_names.include?('reader')
#		end
#
#		def is_user?(user=nil)
#			!user.nil? && self == user
#		end
#		alias_method :may_be_user?, :is_user?
#
#		def may_administrate?(*args)
#			(self.role_names & ['superuser','administrator']).length > 0
#		end
#		alias_method :may_view_permissions?,        :may_administrate?
#		alias_method :may_create_user_invitations?, :may_administrate?
#		alias_method :may_view_users?,              :may_administrate?
#		alias_method :may_assign_roles?,            :may_administrate?
#
#		def may_edit?(*args)
#			(self.role_names & 
#				['superuser','administrator','editor']
#			).length > 0
#		end
#		alias_method :may_maintain_pages?, :may_edit?
#
##	Add tests for may_interview and may_read
#		def may_interview?(*args)
#			(self.role_names & 
#				['superuser','administrator','editor','interviewer']
#			).length > 0
#		end
#
##	This is pretty lame as all current roles can read
#		def may_read?(*args)
#			(self.role_names & 
#				['superuser','administrator','editor','interviewer','reader']
#			).length > 0
#		end
#		alias_method :may_view?, :may_read?
#
#		def may_view_user?(user=nil)
#			self.is_user?(user) || self.may_administrate?
#		end
#
#		def may_share_document?(document=nil)
#			document && ( 
#				self.is_administrator? ||
#				( document.owner && self == document.owner ) 
#			)
#		end
#
#		def may_view_document?(document=nil)
#			document
#		end
#
#		
#		#	defined in plugin/engine ...
#		#
#		#	def may_administrate?(*args)
#		#		(self.role_names & ['superuser','administrator']).length > 0
#		#	end
#		#
#		#	def may_read?(*args)
#		#		(self.role_names & 
#		#			['superuser','administrator','editor','interviewer','reader']
#		#		).length > 0
#		#	end
#		#
#		#	def may_edit?(*args)
#		#		(self.role_names & 
#		#			['superuser','administrator','editor']
#		#		).length > 0
#		#	end
#		#
#		
#		alias_method :may_create?,  :may_edit?
#		alias_method :may_update?,  :may_edit?
#		alias_method :may_destroy?, :may_edit?
#	#	alias_method :may_view?,    :may_read?

		#	This restriction will probably be lightened,
		#	otherwise no one will be able to view other user's profiles
		def may_view_user?(user=nil)
			self.is_user?(user) || self.may_administrate?
		end

		def may_edit_user?(user=nil)
			self.is_user?(user) || self.may_administrate?
		end

#		
#		
#		
#			%w(	announcements events ).each do |resource|
#				alias_method "may_create_#{resource}?".to_sym,  :may_administrate?
#		#		alias_method "may_read_#{resource}?".to_sym,    :may_read?
#				alias_method "may_edit_#{resource}?".to_sym,    :may_administrate?
#				alias_method "may_update_#{resource}?".to_sym,  :may_administrate?
#				alias_method "may_destroy_#{resource}?".to_sym, :may_administrate?
#				define_method("may_read_#{resource}?".to_sym) { true }	#	any user
#			end
#		
#			%w(	memberships group_roles ).each do |resource|
#				alias_method "may_create_#{resource}?".to_sym,  :may_administrate?
#				alias_method "may_read_#{resource}?".to_sym,    :may_administrate?
#				alias_method "may_edit_#{resource}?".to_sym,    :may_administrate?
#				alias_method "may_update_#{resource}?".to_sym,  :may_administrate?
#				alias_method "may_destroy_#{resource}?".to_sym, :may_administrate?
#			end
#		
#			def may_read_forum?(forum)
#				if forum && forum.group
#					may_administrate? || is_group_reader?(forum.group)
#				else
#					true
#				end
#			end
#		
#			def may_edit_forum?(forum)
#				if forum && forum.group
#					may_administrate? || is_group_editor?(forum.group)
#				else
#					may_edit?
#				end
#			end
#		
	end	#	module InstanceMethods
end
