class Membership < ActiveRecord::Base

	belongs_to :user
	belongs_to :group
	belongs_to :group_role

	validations_from_yaml_file

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

end
