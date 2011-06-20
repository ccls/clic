class PostsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_topic_id_required,
		:only => [:new,:create,:index]
#	before_filter :valid_id_required,
#		:only => [:edit,:update,:show,:destroy]
	before_filter :may_edit_forum_required,
		:only => [:new,:create]

	def new
		@post = @topic.posts.new
		@group_document = GroupDocument.new
	end

	def create
		@post = @topic.posts.new(params[:post])
		@post.user = current_user
		@group_document = GroupDocument.new(params[:group_document])
		Post.transaction do
			@post.save!
			unless @group_document.document_file_name.blank?
				@group_document.user = current_user
#				@group_document.post = @post
				@group_document.attachable = @post
				@group_document.group = @forum.group
				@group_document.save!
			end
		end 
		flash[:notice] = "Success!"
		redirect_to topic_path(@topic)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		#	Rails bug does not reset new_record or id on failed transaction
		#	they know and don't care
		@post.instance_variable_set("@new_record", true)
		@post.id = nil
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

#	def valid_id_required
#		if Post.exists?(params[:id])
#			@post = Post.find(params[:id])
#		else
#			access_denied("Valid post id required")	#,members_only_path)
#		end
#	end

end
