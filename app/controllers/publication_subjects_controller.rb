class PublicationSubjectsController < ApplicationController

	orderable

	before_filter :may_create_publication_subjects_required,
		:only => [:new,:create]
	before_filter :may_read_publication_subjects_required,
		:only => [:show,:index]
	before_filter :may_update_publication_subjects_required,
		:only => [:edit,:update]
	before_filter :may_destroy_publication_subjects_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	def index
		@publication_subjects = PublicationSubject.order(:position).all
	end

	def new
		@publication_subject = PublicationSubject.new
	end

	def create
		@publication_subject = PublicationSubject.new(params[:publication_subject])
		@publication_subject.save!
		flash[:notice] = 'Success!'
		redirect_to @publication_subject
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the publication_subject"
		render :action => "new"
	end 

	def update
		@publication_subject.update_attributes!(params[:publication_subject])
		flash[:notice] = 'Success!'
		redirect_to publication_subjects_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the publication_subject"
		render :action => "edit"
	end

	def destroy
		@publication_subject.destroy
		redirect_to publication_subjects_path
	end

protected

	def valid_id_required
		if( params[:id].present? && PublicationSubject.exists?(params[:id]) )
			@publication_subject = PublicationSubject.find(params[:id])
		else
			access_denied("Valid id required!", publication_subjects_path)
		end
	end

end
