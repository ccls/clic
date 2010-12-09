class AddAttachmentsImageToPhoto < ActiveRecord::Migration
	def self.up
		table_name = 'photos'
		cols = columns(table_name).map(&:name)
		add_column( table_name, :image_file_name, :string
			) unless cols.include?('image_file_name')
		add_column( table_name, :image_content_type, :string
			) unless cols.include?('image_content_type')
		add_column( table_name, :image_file_size, :integer
			) unless cols.include?('image_file_size')
		add_column( table_name, :image_updated_at, :datetime
			) unless cols.include?('image_updated_at')
	end

	def self.down
		remove_column :photos, :image_file_name
		remove_column :photos, :image_content_type
		remove_column :photos, :image_file_size
		remove_column :photos, :image_updated_at
	end
end
