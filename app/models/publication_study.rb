class PublicationStudy < ActiveRecord::Base
	belongs_to :publication
	belongs_to :study
	validates_presence_of :publication, :study
	attr_protected :publication_id, :study_id
end
