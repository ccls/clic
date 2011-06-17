class PublicationSubject < ActiveRecord::Base
	acts_as_list

	has_many :publications

	validates_presence_of   :name
	validates_uniqueness_of :name
	validates_length_of     :name,  :maximum => 250

	def to_s
		name
	end

end
