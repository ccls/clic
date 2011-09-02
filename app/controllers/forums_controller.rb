class ForumsController < ApplicationController

	before_filter :valid_id_required,
		:only => [:edit,:update,:show,:destroy]

	before_filter :may_read_forum_required, 
		:only => [:show]
	before_filter :may_create_forum_for_group_required, 
		:only => [:new,:create]
	before_filter :may_edit_forum_required,
		:only => [:edit,:update]
	before_filter :may_moderate_forum_required,
		:only => [:destroy]

	def new
		@forum = Forum.new
	end

	def create
		@forum = Forum.new(params[:forum])
		@forum.group = @group
		@forum.save!
		flash[:notice] = 'Forum successfully created!'
		redirect_to @forum
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = 'Forum creation failed'
		render :action => 'new'
	end

	def update
		@forum.update_attributes!(params[:forum])
		flash[:notice] = 'Forum successfully updated!'
		redirect_to @forum
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Forum update failed"
		render :action => 'edit'
	end

	def destroy
		@forum.destroy
		redirect_to @forum.group || members_only_path
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
			@group = @forum.group if @forum.group
		else
			access_denied("Valid forum id required")
		end
	end

end
