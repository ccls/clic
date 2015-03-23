class PublicationsController < ApplicationController

	before_filter :may_create_publications_required,
		:only => [:new,:create]
	before_filter :may_read_publications_required,
		:only => [:show,:index]
	before_filter :may_update_publications_required,
		:only => [:edit,:update]
	before_filter :may_destroy_publications_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	def index
		@publications = Publication.all
	end

	def new
		#	could include study_ids, so had to make a special method
		@publication = Publication.new(params[:publication])
	end

	def create
		@publication = Publication.new(publication_params)
		@publication.current_user = current_user
		@publication.save!
		flash[:notice] = "Success!"
		redirect_to @publication
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Publication Creation Failed."
		render :action => 'new'
	end

	#
	#	publications are not associated with a user (no user_id)
	#	so even on updates, if a group_document is added, the current_user
	#	must be passed to it so that it can be added to the group_documents
	#
	def update
		@publication.update_attributes(publication_params)
		@publication.current_user = current_user if @publication.current_user.nil?
		@publication.save!
		flash[:notice] = 'Success!'
		redirect_to publications_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the publication"
		render :action => "edit"
	end

	def destroy
		@publication.destroy
		redirect_to publications_path
	end

protected

	def valid_id_required
		if( params[:id].present? && Publication.exists?(params[:id]) )
			@publication = Publication.find(params[:id])
		else
			access_denied("Valid id required!", publications_path)
		end
	end

	def publication_params
		params.require(:publication).permit(:title, :author_last_name, 
			:journal, :publication_year, :url, :publication_subject_id, 
			:other_publication_subject, :study_id, 
			:publication_subject_ids => [], :study_ids => [])
	end

end
