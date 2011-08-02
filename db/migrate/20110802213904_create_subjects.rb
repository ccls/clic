class CreateSubjects < ActiveRecord::Migration
	def self.up
		create_table :subjects do |t|
			t.integer :study_id
			t.integer :subid
			t.string :case_status
			t.string :subtype
			t.string :sex
			t.string :race
			t.text :biospecimens
			t.timestamps
		end
	end

	def self.down
		drop_table :subjects
	end
end
