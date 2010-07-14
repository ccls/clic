class CreateForums < ActiveRecord::Migration
	def self.up
		create_table :forums do |t|
			t.references :group, :null => false
			t.string :name, :null => false
			t.text   :description
			t.timestamps
		end
		add_index :forums, :name, :unique => true
		add_index :forums, :group_id
	end

	def self.down
		drop_table :forums
	end
end
