class Study < ActiveRecord::Base
	acts_as_list

	has_many :publications

	validates_presence_of :name
	validates_uniqueness_of :name

	def to_s
		name
	end

end
