class RecreateSubjects < ActiveRecord::Migration
	def self.up
		drop_table :subjects
		create_table :subjects do |t|
			t.integer :study_id
			t.string  :clic_id
			t.string  :case_control
			t.string  :leukemiatype
			t.string  :immunophenotype
			t.string  :interview_respondent
			t.integer :reference_year
			t.integer :birth_year
			t.string  :gender
			t.integer :age
			t.string  :ethnicity
			t.integer :mother_age_birth
			t.integer :father_age_birth
			t.string  :income_quint
			t.string  :downs
			t.string  :mother_education
			t.string  :father_education
			t.timestamps
		end
	end

	def self.down
		drop_table :subjects
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
end
