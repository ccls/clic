class ProfessionsController < ApplicationController

	orderable

	before_filter :may_create_professions_required,
		:only => [:new,:create]
	before_filter :may_read_professions_required,
		:only => [:show,:index]
	before_filter :may_update_professions_required,
		:only => [:edit,:update]
	before_filter :may_destroy_professions_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	def index
		@professions = Profession.order(:position)
	end

	def new
		@profession = Profession.new
	end

	def create
		@profession = Profession.new(profession_params)
		@profession.save!
		flash[:notice] = 'Success!'
		redirect_to @profession
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the profession"
		render :action => "new"
	end 

	def update
		@profession.update_attributes!(profession_params)
		flash[:notice] = 'Success!'
		redirect_to professions_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the profession"
		render :action => "edit"
	end

	def destroy
		@profession.destroy
		redirect_to professions_path
	end

protected

	def valid_id_required
		if( params[:id].present? && Profession.exists?(params[:id]) )
			@profession = Profession.find(params[:id])
		else
			access_denied("Valid id required!", professions_path)
		end
	end

	def profession_params
		params.require(:profession).permit(:name)
	end

end
