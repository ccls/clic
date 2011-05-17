class AnnualMeeting < ActiveRecord::Base

	validates_presence_of :meeting
	validates_presence_of :abstract

	def to_s
		meeting
	end

end
