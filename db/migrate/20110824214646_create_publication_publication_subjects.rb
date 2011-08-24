class CreatePublicationPublicationSubjects < ActiveRecord::Migration
	def self.up
		create_table :publication_publication_subjects do |t|
			t.integer :publication_id, :null => false
			t.integer :publication_subject_id, :null => false
			t.timestamps
		end
	end

	def self.down
		drop_table :publication_publication_subjects
	end
end
