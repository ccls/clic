class AnnualMeetingsController < ApplicationController

#
#	Annual Meetings are sorted newest first, so need to
#	reverse them if going to use the same 'orderable' code.
#
	before_filter :reverse_ids_for_ordering, :only => :order

	orderable

	before_filter :may_create_annual_meetings_required,
		:only => [:new,:create]
	before_filter :may_read_annual_meetings_required,
		:only => [:show,:index]
	before_filter :may_update_annual_meetings_required,
		:only => [:edit,:update]
	before_filter :may_destroy_annual_meetings_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	def index
		@annual_meetings = AnnualMeeting.order('position DESC')
	end

	def new
		@annual_meeting = AnnualMeeting.new
	end

	def create
		@annual_meeting = AnnualMeeting.new(annual_meeting_params)
		@annual_meeting.current_user = current_user
		@annual_meeting.save!
		flash[:notice] = "Success!"
		redirect_to @annual_meeting
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Annual Meeting Creation Failed."
		render :action => 'new'
	end

	#
	#	annual_meetings are not associated with a user (no user_id)
	#	so even on updates, if a group_document is added, the current_user
	#	must be passed to it so that it can be added to the group_documents
	#
	def update
		@annual_meeting.current_user = current_user
		@annual_meeting.update_attributes!(annual_meeting_params)
		flash[:notice] = 'Success!'
		redirect_to annual_meetings_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the annual_meeting"
		render :action => "edit"
	end

	def destroy
		@annual_meeting.destroy
		redirect_to annual_meetings_path
	end

protected

	def valid_id_required
		if( params[:id].present? && AnnualMeeting.exists?(params[:id]) )
			@annual_meeting = AnnualMeeting.find(params[:id])
		else
			access_denied("Valid id required!", annual_meetings_path)
		end
	end

	def reverse_ids_for_ordering
		params[:ids].reverse! if params[:ids]
	end

	def annual_meeting_params
		params.require(:annual_meeting).permit( :meeting, :abstract,
			:group_documents_attributes => [ :title, :document ] )
	end

end
