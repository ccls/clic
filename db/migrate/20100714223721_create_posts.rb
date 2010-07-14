class CreatePosts < ActiveRecord::Migration
	def self.up
		create_table :posts do |t|
			t.references :user, :null => false
			t.references :topic, :null => false
			t.text :body, :null => false
			t.timestamps
		end
		add_index :posts, :topic_id
		add_index :posts, :user_id
	end

	def self.down
		drop_table :posts
	end
end
