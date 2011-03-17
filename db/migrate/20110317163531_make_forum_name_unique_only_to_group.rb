class MakeForumNameUniqueOnlyToGroup < ActiveRecord::Migration
	def self.up
		remove_index :forums, :name
		add_index :forums, [:group_id,:name], :unique => true
	end

	def self.down
		remove_index :forums, :column => [:group_id,:name]

		puts "This migration will fail with the expected data"
#	If the expected data exists, this would fail
#	as the forums names (by themselves) are NOT unique now
#		add_index :forums, :name, :unique => true
	end
end
