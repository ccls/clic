class PublicationPublicationSubject < ActiveRecord::Base
	belongs_to :publication
	belongs_to :publication_subject
end
