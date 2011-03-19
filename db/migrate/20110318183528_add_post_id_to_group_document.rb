class AddPostIdToGroupDocument < ActiveRecord::Migration
	def self.up
		add_column :group_documents, :post_id, :integer
	end

	def self.down
		remove_column :group_documents, :post_id
	end
end
