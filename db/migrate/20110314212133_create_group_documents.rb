class CreateGroupDocuments < ActiveRecord::Migration
	def self.up
		create_table :group_documents do |t|
			t.integer :group_id, :null => false
			t.integer :user_id, :null => false
			t.string :title
			t.text :description

			t.timestamps
		end
	end

	def self.down
		drop_table :group_documents
	end
end
