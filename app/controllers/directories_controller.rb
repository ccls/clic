class DirectoriesController < ApplicationController
	before_filter :may_read_required
	def show
		@members = User.all
	end
end
