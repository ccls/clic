class AnnualMeetingsController < ApplicationController

	resourceful

	def create
		@annual_meeting = AnnualMeeting.new(params[:annual_meeting])
		@annual_meeting.current_user = current_user
		@annual_meeting.save!
		flash[:notice] = "Success!"
		redirect_to @annual_meeting
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "something bad happened"
		render :action => 'new'
	end

end
