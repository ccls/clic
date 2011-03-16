class AddApprovedToMemberships < ActiveRecord::Migration
	def self.up
		add_column :memberships, :approved, :boolean, :default => false
	end

	def self.down
		remove_column :memberships, :approved
	end
end
