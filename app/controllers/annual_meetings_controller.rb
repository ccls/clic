class AnnualMeetingsController < ApplicationController

	resourceful

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

end
