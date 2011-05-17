class Publication < ActiveRecord::Base

	has_many :publication_subjects

	validates_presence_of :title
	validates_presence_of :journal
	validates_presence_of :publication_year
	validates_presence_of :author_last_name

	def to_s
		title
	end

end
