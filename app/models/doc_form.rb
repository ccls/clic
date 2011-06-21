class DocForm < ActiveRecord::Base

	validates_presence_of :title, :abstract
	validates_length_of   :title,    :maximum => 250
	validates_length_of   :abstract, :maximum => 65000

	has_many   :group_documents, :dependent => :destroy, :as => :attachable

	accepts_nested_attributes_for :group_documents, 
		:reject_if => proc{|attributes| attributes['document'].blank? }

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

end
