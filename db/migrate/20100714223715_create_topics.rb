class CreateTopics < ActiveRecord::Migration
	def self.up
		create_table :topics do |t|
			t.references :user, :null => false
			t.references :forum, :null => false
			t.string :title, :null => false
			t.timestamps
		end
		add_index :topics, :forum_id
	end

	def self.down
		drop_table :topics
	end
end
