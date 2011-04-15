class EventsController < ApplicationController

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
		@event = Event.new(params[:event])
		@event.user = current_user
		@event.save!
		flash[:notice] = "Event created."
		redirect_to members_only_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Something bad happened"
		render :action => 'new'
	end

	def update
#		@event.update_attributes!(params[:event])
		@event.update_attributes(params[:event])
		#	due to some upgrades, it is possible for older events
		#	to not have a user so set it here.
		@event.user = current_user if @event.user.nil?
		@event.save!
		flash[:notice] = 'Success!'
		redirect_to events_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the event"
		render :action => "edit"
	end


protected

	def get_all
		@events = Event.find(:all, :conditions => {
			:group_id => nil })
	end

	def may_not_have_group_required
		@event.group_id && access_denied(
			"This is a restricted group event", members_only_path)
	end

	def may_create_events_required
		current_user.may_create_events? || access_denied(
			"You don't have permission to create events.", 
			members_only_path )
	end

end
