class DocForm < ActiveRecord::Base

	validates_presence_of :title, :abstract
	validates_length_of   :title,    :maximum => 250
	validates_length_of   :abstract, :maximum => 65000

	def to_s
		title
	end

end
