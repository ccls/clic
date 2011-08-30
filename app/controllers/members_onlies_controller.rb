class MembersOnliesController < ApplicationController

	def show
		@announcements = Announcement.groupless
		@cal_events = Announcement.all	#	TODO, but should remove timeless announcements
#	TODO also only get this months
		@forums = Forum.groupless
	end

end
