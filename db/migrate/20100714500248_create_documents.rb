class CreateDocuments < ActiveRecord::Migration
	def self.up
		table_name = 'documents'
		create_table table_name do |t|
			t.references :owner
			t.string :title, :null => false
			t.text   :abstract
			t.boolean :shared_with_all, 
				:default => false, :null => false
			t.boolean :shared_with_select, 
				:default => false, :null => false
			t.timestamps
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :owner_id
			) unless idxs.include?("index_#{table_name}_on_owner_id")
	end

	def self.down
		drop_table :documents
	end
end
