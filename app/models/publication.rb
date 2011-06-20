class Publication < ActiveRecord::Base

	belongs_to :publication_subject
	belongs_to :study
	has_many   :group_documents, :dependent => :destroy, :as => :attachable

# TODO accepts_nested_attributes_for :group_documents

	validates_presence_of :title, :journal, :publication_year, :author_last_name

	validates_length_of :title, :journal,
		:publication_year, :author_last_name,
			:maximum => 250
	validates_length_of :other_publication_subject,  
			:maximum => 250, :allow_blank => true

	def to_s
		title
	end

end
