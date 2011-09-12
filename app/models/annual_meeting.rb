class AnnualMeeting < ActiveRecord::Base

	has_many   :group_documents, :dependent => :destroy, :as => :attachable

	accepts_nested_attributes_for :group_documents, 
		:reject_if => proc{|attributes| attributes['document'].blank? }

	validates_presence_of :meeting, :abstract
	validates_length_of :meeting,  :maximum => 250
	validates_length_of :abstract, :maximum => 65000

	#	solely used to pass the current_user from the controller to the group documents
	attr_accessor :current_user

#	before_validation_on_create  :set_group_documents_user
	before_validation  :set_group_documents_user

	def to_s
		meeting
	end

protected

	def set_group_documents_user
		group_documents.each do |gd|
#	topic will be nil on nested attribute creation, so need to wait
#			gd.group = topic.forum.group
			gd.user  = current_user if gd.user_id.blank?
		end
	end

end
