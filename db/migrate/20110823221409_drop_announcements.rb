class DropAnnouncements < ActiveRecord::Migration
	def self.up
		drop_table :announcements
	end

	def self.down
		create_table :announcements do |t|
			t.string :title, :null => false
			t.text :content, :null => false
			t.integer :user_id, :null => false
			t.integer :group_id
			t.timestamps
		end
	end
end
