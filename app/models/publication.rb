class Publication < ActiveRecord::Base

	belongs_to :publication_subject
	belongs_to :study
	has_many   :group_documents, :dependent => :destroy, :as => :attachable

	accepts_nested_attributes_for :group_documents, 
		:reject_if => proc{|attributes| attributes['document'].blank? }

	validates_presence_of :title, :journal, :publication_year, :author_last_name

	validates_length_of :title, :journal,
		:publication_year, :author_last_name,
			:maximum => 250
	validates_length_of :other_publication_subject,  
			:maximum => 250, :allow_blank => true

	validate :publication_year_is_between_1900_and_this_year

	attr_accessor :current_user

	before_validation_on_create  :set_group_documents_user

	def to_s
		title
	end

protected

	def set_group_documents_user
		group_documents.each do |gd|
#	topic will be nil on nested attribute creation, so need to wait
#			gd.group = topic.forum.group
			gd.user  = current_user
		end
	end

	def publication_year_is_between_1900_and_this_year


#	TODO publication year needs to be between 1900 and current year


	end

end
