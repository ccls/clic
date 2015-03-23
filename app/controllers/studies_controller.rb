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
		@studies = Study.order('name ASC')
	end

	def new
		@study = Study.new
	end

	def create
		@study = Study.new(study_params)
		@study.save!
		flash[:notice] = 'Success!'
		redirect_to @study
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the study"
		render :action => "new"
	end 

	def update
		@study.update_attributes!(study_params)
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
		if( params[:id].present? && Study.exists?(params[:id]) )
			@study = Study.find(params[:id])
		else
			access_denied("Valid id required!", studies_path)
		end
	end

	def study_params
		params.require(:study).permit(:name, :principal_investigator_names, 
			:contact_info, :world_region, :country, :design, :target_age_group, 
			:recruitment, :overview)
	end

end
