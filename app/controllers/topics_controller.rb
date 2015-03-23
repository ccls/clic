class TopicsController < ApplicationController

	before_filter :valid_forum_id_required,
		:only => [:new,:create]
	before_filter :valid_id_required,
		:only => [:show,:edit,:update,:destroy]
	before_filter :may_read_forum_required, 
		:only => [:show]
	before_filter :may_edit_forum_required,
		:only => [:new,:create,:edit,:update]
	before_filter :may_moderate_forum_required,
		:only => [:destroy]

	def new
		@group = @forum.group if @forum.group
		@topic = Topic.new
	end

	def create
		@topic = @forum.topics.new(topic_params)
		@topic.user = current_user
		@topic.save!
		flash[:notice] = "Topic successfully created!"
		redirect_to forum_path(@forum)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Topic creation failed."
		render :action => 'new'
	end

	def update
		@topic.update_attributes!(topic_params)
		flash[:notice] = "Topic successfully updated!"
		redirect_to @topic
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Topic update failed."
		render :action => 'edit'
	end

	def destroy
		@topic.destroy
		redirect_to @topic.forum
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
			@group = @forum.group if @forum.group
		else
			access_denied("Valid topic id required")
		end
	end

	def may_edit_forum_required
		current_user.may_edit_forum?(@forum) || access_denied(
			"You don't have permission to edit this forum",
			forum_path(@forum) )
	end

	def topic_params
		params.require(:topic).permit(:title, 
			:posts_attributes => [
				:body,
					:group_documents_attributes => [ :title, :document ]])
	end

end
