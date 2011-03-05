class GroupsController < ApplicationController

	resourceful

protected

	def get_all
		@groups = Group.roots
	end

end
