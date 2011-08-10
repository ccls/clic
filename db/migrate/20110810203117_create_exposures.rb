class CreateExposures < ActiveRecord::Migration
	def self.up
		create_table :exposures do |t|
			t.integer :study_id
			t.string :category
			t.string :relation_to_child
			t.text :windows
			t.text :types
			t.text :assessments
			t.text :forms_of_contact
			t.text :locations_of_use
			t.timestamps
		end
	end

	def self.down
		drop_table :exposures
	end
end
