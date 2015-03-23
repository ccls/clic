class AnnualMeeting < ActiveRecord::Base

	acts_as_list 

	has_many   :group_documents, :dependent => :destroy, :as => :attachable

	accepts_nested_attributes_for :group_documents, 
		:reject_if => proc{|attributes| attributes['document'].blank? }

	validations_from_yaml_file

	#	solely used to pass the current_user to the group documents
	attr_accessor :current_user

	#	Before validation because group document requires user.
	#	Probably easier if I just removed that validation.
	#	Would need to add a migration as this is also in the database.
  #  t.integer  "user_id", :null => false
	before_validation  :set_group_documents_user

	def to_s
		meeting
	end

protected

	def set_group_documents_user
		group_documents.each do |gd|
			gd.user  = current_user if gd.user_id.blank?
		end
	end

end
