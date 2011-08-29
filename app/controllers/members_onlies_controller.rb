class MembersOnliesController < ApplicationController

	def show
		@announcements = Announcement.groupless
		@forums = Forum.groupless
	end

end
