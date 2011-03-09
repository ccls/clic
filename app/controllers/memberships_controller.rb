class MembershipsController < ApplicationController

	layout 'members_onlies'

	before_filter :group_required,
		:only => [:new,:create,:index]
#	before_filter :nonmember_required,
#		:only => [:new,:create]
	before_filter :membership_required,
		:only => [:edit,:update,:show,:destroy]
#	before_filter :group_moderator_required,
#		:only => [:edit,:update,:destroy]

	before_filter "may_create_memberships_required", :only => [:new,:create]
	before_filter "may_read_memberships_required",   :only => [:index]
	before_filter "may_read_membership_required",    :only => [:show]
	before_filter "may_update_membership_required",  :only => [:edit,:update]
	before_filter "may_destroy_membership_required", :only => [:destroy]

	def index
		@memberships = @group.memberships
	end
	def new
		@membership = @group.memberships.new
	end
	def create
#		create membership (don't use params) without role
		@membership = @group.memberships.new(:user => current_user)
		@membership.save!
		flash[:notice] = "Membership request created."
		redirect_to members_only_path
#	rescue
#puts "Something bad happened"
#		redirect_to members_only_path
	end

	def show
	end
	def edit
	end
	def update
		@membership.update_attributes!(params[:membership])			#	BAD IDEA
		flash[:notice] = 'Success!'
		redirect_to members_only_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the membership"
		render :action => "edit"
	end
	def destroy
		@membership.destroy
		redirect_to members_only_path
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

##	add user method :is_group_moderator?(group)
##	current_user.is_group_moderator?(@group) || access_denied(......
#	def group_moderator_required
#		@group = @membership.group
##		current_user.memberships.find(:first,:conditions => { :group_id => @group.id }
##			).is_moderator? || access_denied("Moderators only",members_only_path)
#		current_user.is_group_moderator?(@group) || 
#			access_denied("Moderators only",members_only_path)
#	end
#
##	add user method :is_group_member?(group)
#	def nonmember_required
#		current_user.memberships.find(:first,:conditions => { :group_id => @group.id }
#			) && access_denied("You are already a member.",members_only_path)
#	end

	def may_create_memberships_required
		current_user.may_create_membership?(@group) || access_denied
	end

	def may_read_memberships_required
		current_user.may_read_memberships?(@group) || access_denied
	end

end
