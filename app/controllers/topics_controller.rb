class TopicsController < ApplicationController

	before_filter :valid_forum_id_required,
		:only => [:new,:create]
	before_filter :valid_id_required,
		:only => [:show]
	before_filter :may_read_forum_required, 
		:only => [:show]
	before_filter :may_edit_forum_required,
		:only => [:new,:create]

	def new
		@group = @forum.group if @forum.group
		@topic = Topic.new
	end

	def create
		@topic = @forum.topics.new(params[:topic])
		@topic.user = current_user
		@topic.save!
		flash[:notice] = "Success!"
		redirect_to forum_path(@forum)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "something bad happened"
		render :action => 'new'
	end

protected

	def valid_forum_id_required
		if Forum.exists?(params[:forum_id])
			@forum = Forum.find(params[:forum_id])
		else
			access_denied("Valid forum id required")
		end
	end

	def valid_id_required
		if Topic.exists?(params[:id])
			@topic = Topic.find(params[:id])
			@forum = @topic.forum
		else
			access_denied("Valid topic id required")
		end
	end

	def may_edit_forum_required
		current_user.may_edit_forum?(@forum) || access_denied(
			"You don't have permission to edit this forum",
			forum_path(@forum) )
	end

end
