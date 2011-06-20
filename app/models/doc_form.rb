class DocForm < ActiveRecord::Base

	validates_presence_of :title, :abstract
	validates_length_of   :title,    :maximum => 250
	validates_length_of   :abstract, :maximum => 65000

	has_many   :group_documents, :dependent => :destroy, :as => :attachable

	accepts_nested_attributes_for :group_documents, 
		:reject_if => proc{|attributes| attributes['document'].blank? }

	def to_s
		title
	end

end
