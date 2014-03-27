class PublicationStudy < ActiveRecord::Base
	belongs_to :publication
	belongs_to :study
	attr_protected :publication_id, :study_id
end
