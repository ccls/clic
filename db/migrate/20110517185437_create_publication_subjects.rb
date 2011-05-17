class CreatePublicationSubjects < ActiveRecord::Migration
	def self.up
		create_table :publication_subjects do |t|
			t.integer :position
#			t.string :code, :null => false
			t.string :name
			t.timestamps
		end
#		add_index :publication_subjects, :code, :unique => true
		add_index :publication_subjects, :name
	end

	def self.down
		drop_table :publication_subjects
	end
end
