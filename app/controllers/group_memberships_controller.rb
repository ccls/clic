class GroupMembershipsController < ApplicationController

	layout 'members_onlies'

#	before_filter :group_required,
#		:only => [:new,:create,:index]
	before_filter :group_required
	before_filter :group_role_required,
		:only => [:update]
	before_filter :membership_required,
		:only => [:edit,:update,:approve,:show,:destroy]

	before_filter "may_create_group_memberships_required", :only => [:new,:create]
	before_filter "may_read_group_memberships_required",   :only => [:index]
	before_filter "may_read_group_membership_required",    :only => [:show]
	before_filter "may_update_group_membership_required",  :only => [:edit,:update,:approve]
	before_filter "may_destroy_group_membership_required", :only => [:destroy]

	def index
		@memberships = @group.memberships
	end

	def new
		@membership = @group.memberships.new
	end

	def create
		@membership = @group.memberships.new
		if( params[:membership] && 
				params[:membership][:group_role_id] &&
				GroupRole.exists?(params[:membership][:group_role_id]) )
			@membership.group_role = GroupRole.find(params[:membership][:group_role_id])
		end
		@membership.user = current_user
		@membership.save!
		flash[:notice] = "Membership request created."
		redirect_to group_path(@group)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Something bad happened"
		render :action => 'new'
	end

	def show
	end

	def edit
	end

	def approve
		@membership.approve!
	rescue ActiveRecord::RecordNotSaved
		flash[:error] = "Membership approval failed"
	ensure
		redirect_to group_memberships_path
	end

	def update
		@membership.group_role = @group_role
		@membership.save!
		flash[:notice] = 'Success!'
		redirect_to group_path(@membership.group)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the membership"
		render :action => "edit"
	end

	def destroy
		@membership.destroy
		redirect_to group_path(@group)
	end

protected

	def membership_required
		if Membership.exists?(params[:id])
			@membership = Membership.find(params[:id])
		else
			access_denied("Membership required",members_only_path)
		end
	end

	def group_required
		if Group.exists?(params[:group_id])
			@group = Group.find(params[:group_id])
		else
			access_denied("Valid group required",members_only_path)
		end
	end

	def group_role_required
		if GroupRole.exists?(params[:membership][:group_role_id])
			@group_role = GroupRole.find(params[:membership][:group_role_id])
		else
			access_denied("Valid group role required",members_only_path)
		end
	end

	def may_create_group_memberships_required
		current_user.may_create_group_membership?(@group) || access_denied
	end

	def may_read_group_memberships_required
		current_user.may_read_group_memberships?(@group) || access_denied
	end

	def may_read_group_membership_required
		current_user.may_read_group_membership?(@membership) || access_denied
	end

#	def may_read_membership_required
#		current_user.may_read_membership?(@group) || access_denied(
#			"special read redirect", new_group_membership_path(@group) )
#	end

	def may_update_group_membership_required
		current_user.may_update_group_membership?(@membership) || access_denied
	end

	def may_destroy_group_membership_required
		current_user.may_destroy_group_membership?(@membership) || access_denied
	end

end
