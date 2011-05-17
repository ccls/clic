class Study < ActiveRecord::Base

	belongs_to :publication

	validates_presence_of :name
	validates_uniqueness_of :name

	def to_s
		name
	end

end
