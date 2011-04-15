class AnnouncementsController < ApplicationController

	resourceful

	layout 'members_onlies'

#	before_filter "may_create_memberships_required", :only => [:new,:create]
#	before_filter "may_read_memberships_required",   :only => [:index]
#	before_filter "may_read_membership_required",    :only => [:show]
#	before_filter "may_update_membership_required",  :only => [:edit,:update]
#	before_filter "may_destroy_membership_required", :only => [:destroy]

	before_filter 'may_not_have_group_required', 
		:only => [:edit,:update,:show,:destroy]

	def create
		@announcement = Announcement.new(params[:announcement])
		@announcement.user = current_user
		@announcement.save!
		flash[:notice] = "Announcement created."
		redirect_to members_only_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Something bad happened"
		render :action => 'new'
	end

	def update
#		@announcement.update_attributes!(params[:announcement])
		@announcement.update_attributes(params[:announcement])
		#	due to some upgrades, it is possible for older announcements
		#	to not have a user so set it here.
		@announcement.user = current_user if @announcement.user.nil?
		@announcement.save!
		flash[:notice] = 'Success!'
		redirect_to announcements_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the announcement"
		render :action => "edit"
	end


protected

	def get_all
		@announcements = Announcement.find(:all, :conditions => {
			:group_id => nil })
	end

	def may_not_have_group_required
		@announcement.group_id && access_denied(
			"This is a restricted group announcement", members_only_path)
	end

	def may_create_announcements_required
		current_user.may_create_announcements? || access_denied(
			"You don't have permission to create announcements.", 
			members_only_path )
	end

end
