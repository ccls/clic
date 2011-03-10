class AnnouncementsController < ApplicationController

	resourceful

	layout 'members_onlies'

#	before_filter "may_create_memberships_required", :only => [:new,:create]
#	before_filter "may_read_memberships_required",   :only => [:index]
#	before_filter "may_read_membership_required",    :only => [:show]
#	before_filter "may_update_membership_required",  :only => [:edit,:update]
#	before_filter "may_destroy_membership_required", :only => [:destroy]

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

end
