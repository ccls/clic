class AnnouncementsController < ApplicationController

	resourceful

	layout 'members_onlies'

#	before_filter "may_create_memberships_required", :only => [:new,:create]
#	before_filter "may_read_memberships_required",   :only => [:index]
#	before_filter "may_read_membership_required",    :only => [:show]
#	before_filter "may_update_membership_required",  :only => [:edit,:update]
#	before_filter "may_destroy_membership_required", :only => [:destroy]

	before_filter 'may_not_have_group_required', :only => [:edit,:update,:show,:destroy]

	def create
		@announcement = Announcement.new(
			params[:announcement].merge(:user_id => current_user.id))
		@announcement.save!
		flash[:notice] = "Announcement created."
		redirect_to members_only_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash[:error] = "Something bad happened"
		render :action => 'new'
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

end
