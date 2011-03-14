class GroupAnnouncementsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_group_id_required
	before_filter :valid_id_required,
		:only => [:edit,:update,:show,:destroy]
	before_filter :announcement_group_required,
		:only => [:edit,:update,:show,:destroy]

	before_filter "may_create_group_announcements_required",  :only => [:new,:create]
	before_filter "may_read_group_announcements_required",    :only => [:index,:show]
	before_filter "may_update_group_announcements_required",  :only => [:edit,:update]
	before_filter "may_destroy_group_announcements_required", :only => [:destroy]

	def index
		@announcements = @group.announcements
	end

	def new
		@announcement = @group.announcements.new
	end

	def create
		@announcement = @group.announcements.new(params[:announcement].merge(
			:user_id => current_user.id))
		@announcement.save!
		flash[:notice] = "Announcement created."
		redirect_to group_path(@announcement.group)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash[:error] = "Something bad happened"
		render :action => 'new'
	end

	def show
	end

	def edit
	end

	def update
		@announcement.update_attributes!(params[:announcement])
		flash[:notice] = 'Success!'
		redirect_to group_path(@announcement.group)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the announcement"
		render :action => "edit"
	end

	def destroy
		@announcement.destroy
		redirect_to group_path(@announcement.group)
	end

protected

	#	double check that the :group_id in the route
	#	and the group_id attribute are the same
	def announcement_group_required
		( @group == @announcement.group ) || access_denied(
			"Group Mismatch",members_only_path)
	end

	def valid_id_required
		if Announcement.exists?(params[:id])
			@announcement = Announcement.find(params[:id])
		else
			access_denied("Valid announcement id required",members_only_path)
		end
	end

	def may_create_group_announcements_required
		current_user.may_create_group_announcements?(@group) || access_denied
	end

	def may_read_group_announcements_required
		current_user.may_read_group_announcements?(@group) || access_denied
	end

	def may_update_group_announcements_required
		current_user.may_update_group_announcements?(@group) || access_denied
	end

	def may_destroy_group_announcements_required
		current_user.may_destroy_group_announcements?(@group) || access_denied
	end

end
