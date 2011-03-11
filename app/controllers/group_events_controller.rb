class GroupEventsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_group_id_required,
		:only => [:new,:create,:index]

	before_filter :valid_id_required,
		:only => [:edit,:update,:show,:destroy]
	before_filter :event_group_required,
		:only => [:edit,:update,:show,:destroy]

	before_filter "may_create_group_events_required",  :only => [:new,:create]
	before_filter "may_read_group_events_required",     :only => [:index,:show]
	before_filter "may_update_group_events_required",  :only => [:edit,:update]
	before_filter "may_destroy_group_events_required", :only => [:destroy]

	def index
		@events = @group.events
	end

	def new
		@event = @group.events.new
	end

	def create
		@event = @group.events.new(params[:event].merge(
			:user_id => current_user.id))
		@event.save!
		flash[:notice] = "Event created."
		redirect_to group_path(@event.group)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash[:error] = "Something bad happened"
		render :action => 'new'
	end

	def show
	end

	def edit
	end

	def update
		@event.update_attributes!(params[:event])
		flash[:notice] = 'Success!'
		redirect_to group_path(@event.group)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the event"
		render :action => "edit"
	end

	def destroy
		@event.destroy
		redirect_to group_path(@event.group)
	end

protected

	#	double check that the :group_id in the route
	#	and the group_id attribute are the same
	def event_group_required
		( @group = @event.group ) || access_denied(
			"Group required",members_only_path)
	end

	def valid_id_required
		if Event.exists?(params[:id])
			@event = Event.find(params[:id])
		else
			access_denied("Valid event id required",members_only_path)
#			access_denied("Valid event id required",group_path(@group))
		end
	end

	def may_create_group_events_required
		current_user.may_create_group_events?(@group) || access_denied
	end

	def may_read_group_events_required
		current_user.may_read_group_events?(@group) || access_denied
	end

	def may_update_group_events_required
		current_user.may_update_group_events?(@group) || access_denied
	end

	def may_destroy_group_events_required
		current_user.may_destroy_group_events?(@group) || access_denied
	end

end
