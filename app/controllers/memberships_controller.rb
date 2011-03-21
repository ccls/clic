class MembershipsController < ApplicationController

#	resourceful

	layout 'members_onlies'
	
	before_filter :membership_required,
		:only => [:update,:destroy]

	before_filter :may_administrate_required

	def index
		@memberships = Membership.all
	end

	def update
		@membership.approved = true
		@membership.updated_at = Time.now
		@membership.save!
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

end
