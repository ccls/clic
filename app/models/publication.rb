class Publication < ActiveRecord::Base

	attr_accessible :author_last_name, :publication_year, :journal, :title, 
		:publication_subject_ids, :study_ids,
		:other_publication_subject, :url, :current_user

#	belongs_to :publication_subject
#	belongs_to :study
#	has_many   :group_documents, :dependent => :destroy, :as => :attachable
	has_many   :publication_publication_subjects
	has_many   :publication_subjects, :through => :publication_publication_subjects
	has_many   :publication_studies
	has_many   :studies, :through => :publication_studies
	validates_presence_of :publication_subject_ids
	validates_presence_of :study_ids

#	accepts_nested_attributes_for :group_documents, 
#		:reject_if => proc{|attributes| attributes['document'].blank? }

#	validates_presence_of :publication_subject, :study

	validates_presence_of :title, :journal, :publication_year, :author_last_name

	validates_length_of :title, :journal, :author_last_name, 
		:other_publication_subject, :url,
			:maximum => 250, :allow_blank => true

	validates_inclusion_of :publication_year, :in => 1900..Time.now.year,
		:message => "should be between 1900 and #{Time.now.year}"

#	validates_presence_of :other_publication_subject, :if => :publication_subject_is_other?

	#	solely used to pass the current_user from the controller to the group documents
	attr_accessor :current_user

#	before_validation_on_create  :set_group_documents_user
#	before_validation  :set_group_documents_user

	def to_s
		title
	end

#
#	Perhaps this would've been better to do in a before_save
#	rather than having to compute this every time the page loads.
#
	def url_with_prefix
		( url.blank? ) ? '' :
			( url.match(/^http(s)?:\/\//) ? url : "http://#{url}" )
	end

protected

#	def set_group_documents_user
#		group_documents.each do |gd|
##	topic will be nil on nested attribute creation, so need to wait
##			gd.group = topic.forum.group
#			gd.user  = current_user if gd.user_id.blank?
#		end
#	end

	#	publication_subject is not yet required, so use try
#	def publication_subject_is_other?
#		publication_subject.try(:is_other?)
#	end

end
