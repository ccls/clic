class MembersOnliesController < ApplicationController

	def show
		#	TODO would like all announcements and events, but will need to consider
		#		and handle this in the links in the views as they are different.
		@announcements = Announcement.groupless	
		@events = Event.groupless
		@forums = Forum.groupless
	end

end
