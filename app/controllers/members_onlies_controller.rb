class MembersOnliesController < ApplicationController

	def show
		@events = Event.groupless
		@forums = Forum.groupless
	end

end
