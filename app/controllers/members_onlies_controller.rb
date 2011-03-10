class MembersOnliesController < ApplicationController

	def show
		@announcements = Announcement.all
		@events = Event.all
	end

end
