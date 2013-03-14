class PublicationPublicationSubject < ActiveRecord::Base
	belongs_to :publication
	belongs_to :publication_subject

#	removed for rails 3
#	validates_presence_of :publication, :publication_subject

	attr_protected :publication_id, :publication_subject_id
end
