class MembersOnliesController < ApplicationController

	def show
		@announcements = Announcement.find(:all, :conditions => {
			:group_id => nil })
		@events = Event.find(:all, :conditions => {
			:group_id => nil })
	end

end
