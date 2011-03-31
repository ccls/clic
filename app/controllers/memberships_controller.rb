class MembershipsController < ApplicationController

	layout 'members_onlies'
	
	before_filter :membership_required,
		:only => [:edit,:update,:approve,:destroy]

	before_filter :may_administrate_required

	before_filter :group_role_required,
		:only => :update

	def index
		@memberships = Membership.all
	end

	def update
		#	should check for a difference, but not necessary
		@membership.group_role = @group_role
		@membership.save!
	rescue ActiveRecord::RecordNotSaved
		flash[:error] = "Membership update failed"
	ensure
		redirect_to memberships_path
	end

	def approve
		@membership.approve!
	rescue ActiveRecord::RecordNotSaved
		flash[:error] = "Membership approval failed"
	ensure
		redirect_to memberships_path
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

	def group_role_required
		if params[:membership] && params[:membership][:group_role_id] &&
				GroupRole.exists?(params[:membership][:group_role_id])
			@group_role = GroupRole.find(params[:membership][:group_role_id])
		else
			access_denied("Group Role required",memberships_path)
		end
	end

end
