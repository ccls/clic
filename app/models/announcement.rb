class Announcement < ActiveRecord::Base
	belongs_to :user
	belongs_to :group

	validates_presence_of :user, :title, :content
	validates_length_of :title,   :maximum => 250
	validates_length_of :content, :maximum => 65000

	attr_protected :group_id, :user_id

	named_scope :groupless, :conditions => {
		:group_id => nil }

	def to_s
		title
	end

end
