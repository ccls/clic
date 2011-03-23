class TopicsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_forum_id_required,
		:only => [:new,:create]
	before_filter :valid_id_required,
		:only => [:show]
	before_filter :may_read_forum_required, 
		:only => [:show]
	before_filter :may_edit_forum_required,
		:only => [:new,:create]

	def new
		@topic = Topic.new
		@post  = @topic.posts.build
		@group_document = GroupDocument.new
	end

	def create
		@topic = @forum.topics.new(params[:topic])
		@topic.user = current_user
		@post = Post.new(params[:post])
		@post.user = current_user
		@group_document = GroupDocument.new(params[:group_document])
		Topic.transaction do
			@topic.save!
			@post.topic = @topic
			@post.save!
			unless @group_document.document_file_name.blank?
				@group_document.user = current_user
				@group_document.group = @forum.group
				@group_document.post = @post
				@group_document.save! 
			end
		end
		flash[:notice] = "Success!"
		redirect_to forum_path(@forum)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		#	Rails bug does not reset new_record or id on failed transaction
		#	they know and don't care
		@topic.instance_variable_set("@new_record", true)
		@topic.id = nil
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
