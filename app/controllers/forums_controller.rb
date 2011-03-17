class ForumsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_id_required,
		:only => [:edit,:update,:show,:destroy]

	before_filter :may_read_forum_required, :only => [:show]

protected

	def valid_id_required
		if Forum.exists?(params[:id])
			@forum = Forum.find(params[:id])
		else
			access_denied("Valid forum id required")
		end
	end

end
