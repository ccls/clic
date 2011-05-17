class CreateStudies < ActiveRecord::Migration
	def self.up
		create_table :studies do |t|
			t.integer :position
			t.string :name
			t.timestamps
		end
		add_index :studies, :name
	end

	def self.down
		drop_table :studies
	end
end
