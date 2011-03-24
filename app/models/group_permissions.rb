#
#		Created primarily for clarity
#
module GroupPermissions


	def self.included(base)
#		base.send(:include, InstanceMethods)
#		base.class_eval do
#			#	may_edit? isn't defined in this module so these need class_eval'd
#			#	unless I completely redefine them all here (probably best if i did)
#			alias_method :may_create?,  :may_edit?
#			alias_method :may_update?,  :may_edit?
#			alias_method :may_destroy?, :may_edit?
#		#	alias_method :may_view?,    :may_read?
#		end
	end



	def group_membership_roles(group)
		approved_memberships.select{|m| m.group_id == group.id }.collect(&:group_role).compact
	end

	def group_membership_role_names(group)
		group_membership_roles(group).collect(&:name)
	end

	def is_group_moderator?(group)
#		memberships.find(:all,:conditions => [
#			'memberships.group_id = ? AND group_roles.name IN (?)', group.id, 
#			['administrator','moderator'] ],
#			:joins => 'LEFT JOIN group_roles on memberships.group_role_id = group_roles.id'
#			).length > 0
		( group_membership_role_names(group) & ['administrator','moderator'] ).length > 0
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
#		memberships.find(:all,:conditions => [
#			'memberships.group_id = ? AND memberships.group_role_id IS NOT NULL', group.id]
#			).length > 0
#	effectively the same as is_group_reader?
		group_membership_role_names(group).length > 0
	end

end
