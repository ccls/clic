class PostsController < ApplicationController

	before_filter :valid_id_required,
		:only => [:edit,:update,:destroy]
	before_filter :may_moderate_forum_required,
		:only => [:edit,:update,:destroy]

	before_filter :valid_topic_id_required,
		:only => [:new,:create,:index]
	before_filter :may_edit_forum_required,
		:only => [:new,:create]

	def new
		@post = @topic.posts.new
	end

	def create
		@post = @topic.posts.new(post_params)
		@post.user = current_user
		@post.save!
		flash[:notice] = "Success!"
		redirect_to topic_path(@topic)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Post creation failed"
		render :action => 'new'
	end

	def update
		@post.update_attributes!(post_params)
		flash[:notice] = "Post updated"
		redirect_to @post.topic
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Post updation failed"
		render :action => 'edit'
	end

	def destroy
		@post.destroy
		flash[:notice] = "Post destroyed"
		redirect_to @post.topic
	end

protected

	def valid_id_required
		if Post.exists?(params[:id])
			@post  = Post.find(params[:id])
			#	needed for permissions, as is method_missing and singular so
			#		will be passed to may_moderate_forum?(@forum) when
			#		may_moderate_forum_required is called
			@forum = @post.topic.forum	
		else
			access_denied("Valid post id required")
		end
	end

	def valid_topic_id_required
		if Topic.exists?(params[:topic_id])
			@topic = Topic.find(params[:topic_id])
			#	needed for permissions, as is method_missing and singular so
			#		will be passed to may_edit_forum?(@forum) when
			#		may_edit_forum_required is called
			@forum = @topic.forum									
		else
			access_denied("Valid topic id required")	#,members_only_path)
		end
	end

	def post_params
		params.require(:post).permit(:body,
			:group_documents_attributes => [:title, :document])
	end

end
