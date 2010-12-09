class AddAttachmentsDocumentToDocument < ActiveRecord::Migration
	def self.up
		table_name = 'documents'
		cols = columns(table_name).map(&:name)
		add_column( table_name, :document_file_name, :string
			) unless cols.include?('document_file_name')
		add_column( table_name, :document_content_type, :string
			) unless cols.include?('document_content_type')
		add_column( table_name, :document_file_size, :integer
			) unless cols.include?('document_file_size')
		add_column( table_name, :document_updated_at, :datetime
			) unless cols.include?('document_updated_at')

		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :document_file_name, :unique => true
			) unless idxs.include?("index_#{table_name}_on_document_file_name")
	end

	def self.down
		remove_index :documents, :document_file_name

		remove_column :documents, :document_file_name
		remove_column :documents, :document_content_type
		remove_column :documents, :document_file_size
		remove_column :documents, :document_updated_at
	end
end
