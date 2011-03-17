class MembersOnliesController < ApplicationController

	def show
		@announcements = Announcement.groupless
		@events = Event.groupless
		@forums = Forum.groupless
	end

end
