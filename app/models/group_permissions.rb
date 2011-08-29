#
#		Created primarily for clarity
#
module GroupPermissions

	def self.included(base)
		base.send(:include, InstanceMethods)
#		base.class_eval do
#			#	may_edit? isn't defined in this module so these need class_eval'd
#			#	unless I completely redefine them all here (probably best if i did)
#			alias_method :may_create?,  :may_edit?
#			alias_method :may_update?,  :may_edit?
#			alias_method :may_destroy?, :may_edit?
#		#	alias_method :may_view?,    :may_read?
#		end
	end

	module InstanceMethods

		def group_membership_roles(group)
			approved_memberships.select{|m| m.group_id == group.id }.collect(&:group_role).compact
		end

		def group_membership_role_names(group)
			group_membership_roles(group).collect(&:name)
		end

		def is_group_moderator?(group)
			( group_membership_role_names(group) & [
				'administrator','moderator'] ).length > 0
		end

		def is_group_editor?(group)
			( group_membership_role_names(group) & [
				'administrator','moderator','editor'] ).length > 0
		end

		def is_group_reader?(group)
			( group_membership_role_names(group) & [
				'administrator','moderator','editor','reader'] ).length > 0
		end

		def is_group_member?(group)
			group_membership_role_names(group).length > 0
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
				may_read? || approved?
			end
		end
	
		#
		#	Group Announcements
		#
		#	Only members can new/create a group announcement
		def may_create_group_announcements?(group)
			may_administrate? || is_group_editor?(group)
		end
	
		#	Only admins and group moderators can edit/update
		def may_update_group_announcements?(group)
			may_administrate? || is_group_editor?(group)
		end
		alias_method :may_edit_group_announcements?, :may_update_group_announcements?
	
		#	Only admins, group members can edit/update
		def may_read_group_announcements?(group)
			may_administrate? || is_group_reader?(group)
		end
	
		#	Only admins and group moderators can destroy the group announcements
		def may_destroy_group_announcements?(group)
			may_administrate? || is_group_moderator?(group)
		end
	
		#
		#			Groups
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


		def may_read_forum?(forum)
			if forum && forum.group
				may_administrate? || is_group_reader?(forum.group)
			else
				may_read? || approved?
			end
		end

		def may_edit_forum?(forum)
			if forum && forum.group
				may_administrate? || is_group_editor?(forum.group)
			else
				may_edit?
			end
		end

		def may_create_forum_for_group?(group)
			if group
				may_administrate? || is_group_moderator?(group)
			else
				may_edit?
			end
		end

	end	#	module InstanceMethods

end
