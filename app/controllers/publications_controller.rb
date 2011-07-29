class PublicationsController < ApplicationController

#	layout 'members_onlies'

	resourceful

	def create
		@publication = Publication.new(params[:publication])
		@publication.current_user = current_user
		@publication.save!
		flash[:notice] = "Success!"
		redirect_to @publication
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "something bad happened"
		render :action => 'new'
	end

end
