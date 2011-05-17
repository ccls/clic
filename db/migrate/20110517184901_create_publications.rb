class CreatePublications < ActiveRecord::Migration
	def self.up
		create_table :publications do |t|
			t.integer :publication_subject_id
			t.integer :study_id
			t.string :author_last_name
			t.string :publication_year
			t.string :journal
			t.string :title
			t.string :other_publication_subject
			t.timestamps
		end
		add_index :publications, :publication_subject_id
		add_index :publications, :study_id
	end

	def self.down
		drop_table :publications
	end
end
