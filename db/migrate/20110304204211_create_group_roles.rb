class CreateGroupRoles < ActiveRecord::Migration
	def self.up
		create_table :group_roles do |t|
			t.integer :position
			t.string :name
			t.timestamps
		end
	end

	def self.down
		drop_table :group_roles
	end
end
