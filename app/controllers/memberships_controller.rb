class MembershipsController < ApplicationController

#	resourceful

	layout 'members_onlies'
	
	before_filter :membership_required,
		:only => [:edit,:update,:destroy]

	before_filter :may_administrate_required

	def index
		@memberships = Membership.all
	end

	def update
		if params[:membership] && params[:membership][:group_role_id] &&
				GroupRole.exists?(params[:membership][:group_role_id])
			@membership.group_role = GroupRole.find(params[:membership][:group_role_id])
		else
			@membership.approved = true
		end
		@membership.updated_at = Time.now
		@membership.save!
		redirect_to memberships_path
#	rescue ???
#
#
	end

	def destroy
		@membership.destroy
		redirect_to memberships_path
	end

protected

	def membership_required
		if Membership.exists?(params[:id])
			@membership = Membership.find(params[:id])
		else
			access_denied("Membership required",memberships_path)
		end
	end

end
