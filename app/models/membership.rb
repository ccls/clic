class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	belongs_to :group_role

	def is_administrator?
		['administrator'].include?(group_role.try(:name))
	end

	def is_moderator?
		['administrator','moderator'].include?(group_role.try(:name))
	end

	def is_editor?
		['administrator','moderator','editor'].include?(group_role.try(:name))
	end

	def is_reader?
		['administrator','moderator','editor','reader'].include?(group_role.try(:name))
	end

end
