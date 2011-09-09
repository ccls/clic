class RemoveStudyIdAndPublicationSubjectIdFromPublications < ActiveRecord::Migration
	def self.up
		remove_column :publications, :study_id
		remove_column :publications, :publication_subject_id
	end

	def self.down
		add_column :publications, :study_id, :integer
		add_column :publications, :publication_subject_id, :integer
	end
end
