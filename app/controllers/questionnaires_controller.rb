class QuestionnairesController < ApplicationController

	before_filter :may_create_questionnaires_required,
		:only => [:new,:create]
	before_filter :may_read_questionnaires_required, 
		:only => [:show,:index,:download]
	before_filter :may_update_questionnaires_required,
		:only => [:edit,:update]
	before_filter :may_destroy_questionnaires_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy,:download]

	def download
		if @questionnaire.document.path.blank?
			flash[:error] = "Does not contain a document"
			redirect_to @questionnaire
		elsif @questionnaire.document.exists?
			if @questionnaire.document.options[:storage] == :filesystem
				#	basically development or non-s3 setup
				send_file @questionnaire.document.path
			else
				#	basically a private s3 file
				redirect_to @questionnaire.document.expiring_url
			end
		else
			flash[:error] = "Document does not exist at the expected location."
			redirect_to @questionnaire
		end
	end

	def index
		@questionnaires = Questionnaire.all
	end

	def new
		@questionnaire = Questionnaire.new(:study_id => params[:study_id])
	end

	def create
		@questionnaire = Questionnaire.new(params[:questionnaire])
		@questionnaire.save!
		flash[:notice] = 'Success!'
		redirect_to @questionnaire
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the questionnaire"
		render :action => "new"
	end 

	def update
		@questionnaire.update_attributes!(params[:questionnaire])
		flash[:notice] = 'Success!'
		redirect_to questionnaires_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the questionnaire"
		render :action => "edit"
	end

	def destroy
		@questionnaire.destroy
		redirect_to questionnaires_path
	end

protected

	def valid_id_required
		if( !params[:id].blank? && Questionnaire.exists?(params[:id]) )
			@questionnaire = Questionnaire.find(params[:id])
		else
			access_denied("Valid id required!", questionnaires_path)
		end
	end

end
