class AddPostsCountToForums < ActiveRecord::Migration
	def self.up
		add_column :forums, :posts_count, :integer, :default => false
	end

	def self.down
		remove_column :forums, :posts_count
	end
end
