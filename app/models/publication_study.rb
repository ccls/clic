class PublicationStudy < ActiveRecord::Base
	belongs_to :publication
	belongs_to :study
end
