class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	belongs_to :group_role

	before_validation :nullify_blank_group_role_id

	def nullify_blank_group_role_id
		self.group_role_id = nil if group_role_id.blank?
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
