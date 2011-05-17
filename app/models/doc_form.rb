class DocForm < ActiveRecord::Base

	validates_presence_of :title
	validates_presence_of :abstract

	def to_s
		title
	end

end
