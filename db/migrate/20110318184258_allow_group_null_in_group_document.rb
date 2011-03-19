class AllowGroupNullInGroupDocument < ActiveRecord::Migration
	def self.up
		change_column :group_documents, :group_id, :integer, :null => true
	end

	def self.down
		puts "This migration will fail with the expected data"
#	If the expected data exists, this would fail
#	as the there are forums with group_id = null
#		change_column :group_documents, :group_id, :integer, :null => false
	end
end
