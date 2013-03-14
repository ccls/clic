class AnnouncementsController < ApplicationController

	before_filter :may_create_announcements_required,
		:only => [:new,:create]
	before_filter :may_read_announcements_required,
		:only => [:show,:index]
	before_filter :may_update_announcements_required,
		:only => [:edit,:update]
	before_filter :may_destroy_announcements_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	before_filter :may_not_have_group_required, 
		:only => [:edit,:update,:show,:destroy]

	def index
		@announcements = Announcement.where(:group_id => nil ).order('created_at DESC, begins_on DESC').all
	end

	def new
		@announcement = Announcement.new
	end

	def create
		@announcement = Announcement.new(params[:announcement])
		@announcement.user = current_user
		@announcement.save!
		flash[:notice] = "Announcement created."
		redirect_to members_only_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the announcement"
		render :action => 'new'
	end

	def update
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

	def destroy
		@announcement.destroy
		redirect_to announcements_path
	end

protected

	def valid_id_required
		if( !params[:id].blank? && Announcement.exists?(params[:id]) )
			@announcement = Announcement.find(params[:id])
		else
			access_denied("Valid id required!", announcements_path)
		end
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
