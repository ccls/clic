class ForumsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_id_required,
		:only => [:edit,:update,:show,:destroy]

	before_filter :may_read_forum_required, :only => [:show]
	before_filter :may_create_forum_for_group_required, :only => [:new,:create]

	def new
		@forum = Forum.new
	end

	def create
		@forum = Forum.new(params[:forum])
		@forum.group = @group
		@forum.save!
		flash[:notice] = 'Forum creation successful!'
		redirect_to @forum
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash[:error] = 'Forum creation failed'
		render :action => 'new'
	end

protected

	def may_create_forum_for_group_required
		@group = (( Group.exists?(params[:group_id]) ) ? Group.find(params[:group_id]) : nil )
		current_user.may_create_forum_for_group?(@group) || access_denied(
			'some message', members_only_path )
	end

	def valid_id_required
		if Forum.exists?(params[:id])
			@forum = Forum.find(params[:id])
		else
			access_denied("Valid forum id required")
		end
	end

end
