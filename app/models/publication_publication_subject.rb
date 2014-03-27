class PublicationPublicationSubject < ActiveRecord::Base
	belongs_to :publication
	belongs_to :publication_subject
	attr_protected :publication_id, :publication_subject_id
end
