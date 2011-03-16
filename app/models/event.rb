class Event < ActiveRecord::Base
	belongs_to :user
	belongs_to :group

	validates_presence_of :user
	validates_presence_of :title
	validates_presence_of :content
	validates_presence_of :begins_on
	validates_complete_date_for :begins_on

#	protect user_id and group_id

	def to_s
		title
	end

end
