class AddSubgroupFieldsToGroup < ActiveRecord::Migration
	def self.up
		change_table :groups do |t|
			t.integer :position
			t.integer :parent_id
			t.integer :groups_count, :default => 0
		end
	end

	def self.down
		change_table :groups do |t|
			t.remove :position
			t.remove :parent_id
			t.remove :groups_count
		end
	end
end
