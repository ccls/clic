class ForumsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_id_required,
		:only => [:edit,:update,:show,:destroy]

	before_filter :may_read_forum_required, :only => [:show]
	before_filter :may_create_forum_for_group_required, :only => [:new,:create]

#	TODO add new
#	TODO add create

protected

#	TODO add :may_create_forum_for_group_required(group)
#	TODO add routes for new/create forum /groups/:id/forum with and without group
#	TODO add check for group_id param

	def may_create_forum_for_group_required
#		group = (( Group.exists?(params[:group_id]) ) ? Group.find(params[:group_id]) : nil )
#		current_user.may_create_forum_for_group(group) || access_denied(
#			'some message', some_route_path )
		true
	end

	def valid_id_required
		if Forum.exists?(params[:id])
			@forum = Forum.find(params[:id])
		else
			access_denied("Valid forum id required")
		end
	end

end
