class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	belongs_to :group_role
	validates_presence_of :user
	validates_presence_of :group

#	Is this really needed????
#	Let's see!
#	before_validation :nullify_blank_group_role_id
#
#	def nullify_blank_group_role_id
#		self.group_role_id = nil if group_role_id.blank?
#	end

	attr_protected :approved
	attr_protected :group_id
	attr_protected :user_id
	attr_protected :group_role_id

#	after_create, if not approved, send membership_approval email

	def approved?
		approved
	end

	def to_s
		"#{user}/#{group}/#{group_role}"
	end

#	def is_administrator?
#		['administrator'].include?(group_role.try(:name))
#	end
#
#	def is_moderator?
#		['administrator','moderator'].include?(group_role.try(:name))
#	end
#
#	def is_editor?
#		['administrator','moderator','editor'].include?(group_role.try(:name))
#	end
#
#	def is_reader?
#		['administrator','moderator','editor','reader'].include?(group_role.try(:name))
#	end

end
