class GroupRolesController < ApplicationController

	before_filter :may_create_group_roles_required,
		:only => [:new,:create]
	before_filter :may_read_group_roles_required,
		:only => [:show,:index]
	before_filter :may_update_group_roles_required,
		:only => [:edit,:update]
	before_filter :may_destroy_group_roles_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	def index
		@group_roles = GroupRole.all
	end

	def new
		@group_role = GroupRole.new
	end

	def create
		@group_role = GroupRole.new(group_role_params)
		@group_role.save!
		flash[:notice] = 'Success!'
		redirect_to @group_role
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the group_role"
		render :action => "new"
	end 

	def update
		@group_role.update_attributes!(group_role_params)
		flash[:notice] = 'Success!'
		redirect_to group_roles_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the group_role"
		render :action => "edit"
	end

	def destroy
		@group_role.destroy
		redirect_to group_roles_path
	end

protected

	def valid_id_required
		if( params[:id].present? && GroupRole.exists?(params[:id]) )
			@group_role = GroupRole.find(params[:id])
		else
			access_denied("Valid id required!", group_roles_path)
		end
	end

	def group_role_params
		params.require(:group_role).permit(:name)
	end

end
