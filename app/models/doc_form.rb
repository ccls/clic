class DocForm < ActiveRecord::Base

	validations_from_yaml_file

	has_many   :group_documents, :dependent => :destroy, :as => :attachable

	accepts_nested_attributes_for :group_documents, 
		:reject_if => proc{|attributes| attributes['document'].blank? }

	#	solely used to pass the current_user from the controller to the group documents
	attr_accessor :current_user

	before_validation  :set_group_documents_user

	def to_s
		title
	end

protected

	def set_group_documents_user
		group_documents.each do |gd|
			gd.user  = current_user if gd.user_id.blank?
		end
	end

end
