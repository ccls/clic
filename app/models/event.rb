class Event < ActiveRecord::Base
	default_scope :order => 'begins_on DESC'
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

	def begins
		( begins_on.nil? ) ? '' : begins_on.strftime("%m/%d/%Y")
	end

	def ends
		( ends_on.nil? ) ? '' : ends_on.strftime("%m/%d/%Y")
	end

	def time
		time = begins
		unless ends.blank?
			time << " - #{ends}"
		end
		time
	end

end
