class GroupsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]
	before_filter "may_create_groups_required", :only => [:new,:create]
	before_filter "may_read_groups_required",   :only => [:index]
	before_filter "may_read_group_required",    :only => [:show]
	before_filter "may_update_group_required",  :only => [:edit,:update]
	before_filter "may_destroy_group_required", :only => [:destroy]

	def index
		@groups = Group.roots
	end

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(params[:group])
		@group.save!
		flash[:notice] = 'Success!'
		redirect_to @group
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the group"
		render :action => "new"
	end 

	def update
		@group.update_attributes!(params[:group])
		flash[:notice] = 'Success!'
		redirect_to groups_path	#		root_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the group"
		render :action => "edit"
	end

	def destroy
		@group.destroy
		redirect_to groups_path				#	root_path
	end

protected

	def valid_id_required
		if( !params[:id].blank? && Group.exists?(params[:id]) )
			@group = Group.find(params[:id])
			@memberships = @group.memberships
		else
			access_denied("Valid id required!", groups_path)
		end
	end

	def may_read_group_required
		current_user.may_read_group?(@group) || access_denied(
			"special read redirect", new_group_membership_path(@group) )
	end

end
