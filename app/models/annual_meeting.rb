class AnnualMeeting < ActiveRecord::Base

	has_many   :group_documents, :dependent => :destroy, :as => :attachable

# TODO accepts_nested_attributes_for :group_documents

	validates_presence_of :meeting, :abstract
	validates_length_of :meeting,  :maximum => 250
	validates_length_of :abstract, :maximum => 65000

	def to_s
		meeting
	end

end
