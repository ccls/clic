class Publication < ActiveRecord::Base

	belongs_to :publication_subject
	belongs_to :study
	has_many   :group_documents, :dependent => :destroy, :as => :attachable

	accepts_nested_attributes_for :group_documents, 
		:reject_if => proc{|attributes| attributes['document'].blank? }

	validates_presence_of :publication_subject, :study

	validates_presence_of :title, :journal, :publication_year, :author_last_name

	validates_length_of :title, :journal, :author_last_name, :maximum => 250
	validates_length_of :other_publication_subject, :maximum => 250, :allow_blank => true

	validates_inclusion_of :publication_year, :in => 1900..Time.now.year,
		:message => "should be between 1900 and #{Time.now.year}"

	validates_presence_of :other_publication_subject, :if => :publication_subject_is_other?

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

	#	publication_subject is not yet required, so use try
	def publication_subject_is_other?
		publication_subject.try(:is_other?)
	end

end
