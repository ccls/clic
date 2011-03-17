class Event < ActiveRecord::Base
	belongs_to :user
	belongs_to :group

	validates_presence_of :user
	validates_presence_of :title
	validates_presence_of :content
	validates_presence_of :begins_on
	validates_complete_date_for :begins_on

	attr_protected :group_id
	attr_protected :user_id

	named_scope :groupless, :conditions => {
		:group_id => nil }

	def to_s
		title
	end

end
