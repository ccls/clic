class StudiesController < ApplicationController

	before_filter :may_create_studies_required,
		:only => [:new,:create]
	before_filter :may_read_studies_required,
		:only => [:show,:index]
	before_filter :may_update_studies_required,
		:only => [:edit,:update]
	before_filter :may_destroy_studies_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	def index
		@studies = Study.all
	end

	def new
		@study = Study.new
	end

	def create
		@study = Study.new(params[:study])
		@study.save!
		flash[:notice] = 'Success!'
		redirect_to @study
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the study"
		render :action => "new"
	end 

	def update
		@study.update_attributes!(params[:study])
		flash[:notice] = 'Success!'
		redirect_to studies_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the study"
		render :action => "edit"
	end

	def destroy
		@study.destroy
		redirect_to studies_path
	end

protected

	def valid_id_required
		if( !params[:id].blank? && Study.exists?(params[:id]) )
			@study = Study.find(params[:id])
		else
			access_denied("Valid id required!", studies_path)
		end
	end


end
