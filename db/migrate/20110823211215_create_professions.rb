class CreateProfessions < ActiveRecord::Migration
	def self.up
		create_table :professions do |t|
			t.integer :position
			t.string  :name, :null => false
			t.timestamps
		end
		add_index :professions, :name, :unique => true
	end

	def self.down
		drop_table :professions
	end
end
