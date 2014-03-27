class Membership < ActiveRecord::Base

#	default scopes are EVIL.  They seem to take precedence
#	over you actual query which seems really stupid
#	removing all in rails 3 which will probably require
#	modifications to compensate in the methods that expected them
#	default_scope :order => 'approved'

	belongs_to :user
	belongs_to :group
	belongs_to :group_role
#	validates_presence_of :user, :group

	validations_from_yaml_file

#	Is this really needed????
#	Let's see!
#	before_validation :nullify_blank_group_role_id
#
#	def nullify_blank_group_role_id
#		self.group_role_id = nil if group_role_id.blank?
#	end

	attr_protected :approved, :group_id, :user_id, :group_role_id

#	after_create, if not approved, send membership_approval email

	after_save :approve_user_if_approved

	def approve_user_if_approved
		if self.approved? and !self.user.approved?
			#	NOTE DO NOT CHANGE USER'S perishable_token, in case the user has not
			#	confirmed their email yet, to preserve the confirmation email's link.
			User.disable_perishable_token_maintenance = true
			self.user.approve! 
			User.disable_perishable_token_maintenance = false
		end
	end

	def approve!
		self.approved = true
		save!
		self
	end

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
