class CreateAnnouncements < ActiveRecord::Migration
	def self.up
		create_table :announcements do |t|
			t.string :title, :null => false
			t.text :content, :null => false
			t.integer :user_id, :null => false
			t.integer :group_id
			t.timestamps
		end
	end

	def self.down
		drop_table :announcements
	end
end
