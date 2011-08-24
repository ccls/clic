class CreatePublicationStudies < ActiveRecord::Migration
	def self.up
		create_table :publication_studies do |t|
			t.integer :publication_id, :null => false
			t.integer :study_id, :null => false
			t.timestamps
		end
	end

	def self.down
		drop_table :publication_studies
	end
end
