class PostsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_topic_id_required,
		:only => [:new,:create,:index]
	before_filter :may_edit_forum_required,
		:only => [:new,:create]

	def new
		@post = @topic.posts.new
	end

	def create
		@post = @topic.posts.new(params[:post])
		@post.user = current_user
		@post.save!
		flash[:notice] = "Success!"
		redirect_to topic_path(@topic)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "something bad happened"
		render :action => 'new'
	end

protected

	def valid_topic_id_required
		if Topic.exists?(params[:topic_id])
			@topic = Topic.find(params[:topic_id])
			@forum = @topic.forum	#	needed for permissions
		else
			access_denied("Valid topic id required")	#,members_only_path)
		end
	end

end
