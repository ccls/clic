class CreateGroupsUsers < ActiveRecord::Migration
	def self.up
		create_table :groups_users, :id => false do |t|
			t.references :group
			t.references :user
		end
		add_index :groups_users, :group_id
		add_index :groups_users, :user_id
	end

	def self.down
		drop_table :groups_users
	end
end
