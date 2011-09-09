class PublicationsController < ApplicationController

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

#
#	publications are not associated with a user (no user_id)
#	so even on updates, if a group_document is added, the current_user
#	must be passed to it so that it can be added
#
	def update
		@publication.update_attributes(params[:publication])
		@publication.current_user = current_user if @publication.current_user.nil?
		@publication.save!
		flash[:notice] = 'Success!'
		redirect_to publications_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the publication"
		render :action => "edit"
	end

protected

	def get_new
		@publication = Publication.new(params[:publication])
	end

end
