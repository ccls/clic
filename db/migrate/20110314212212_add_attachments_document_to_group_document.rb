class AddAttachmentsDocumentToGroupDocument < ActiveRecord::Migration
	def self.up
		add_column :group_documents, :document_file_name, :string
		add_column :group_documents, :document_content_type, :string
		add_column :group_documents, :document_file_size, :integer
		add_column :group_documents, :document_updated_at, :datetime
	end

	def self.down
		remove_column :group_documents, :document_file_name
		remove_column :group_documents, :document_content_type
		remove_column :group_documents, :document_file_size
		remove_column :group_documents, :document_updated_at
	end
end
