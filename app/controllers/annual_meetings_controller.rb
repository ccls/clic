class AnnualMeetingsController < ApplicationController

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
		@annual_meetings = AnnualMeeting.all
	end

	def new
		@annual_meeting = AnnualMeeting.new
	end

	def create
		@annual_meeting = AnnualMeeting.new(params[:annual_meeting])
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
		@annual_meeting.update_attributes(params[:annual_meeting])
		@annual_meeting.current_user = current_user if @annual_meeting.current_user.nil?
		@annual_meeting.save!
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
		if( !params[:id].blank? && AnnualMeeting.exists?(params[:id]) )
			@annual_meeting = AnnualMeeting.find(params[:id])
		else
			access_denied("Valid id required!", annual_meetings_path)
		end
	end

end
