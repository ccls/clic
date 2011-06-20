class PolymorphicizeGroupDocumentAssociation < ActiveRecord::Migration
	def self.up
		rename_column :group_documents, :post_id, :attachable_id
#	set default to Post as that was the original purpose
		add_column    :group_documents, :attachable_type, :string, :default => 'Post'
	end

	def self.down
		remove_column :group_documents, :attachable_type
		rename_column :group_documents, :attachable_id, :post_id
	end
end
