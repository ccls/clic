class QuestionnairesController < ApplicationController

	resourceful

	#	Can't add an action to actions for existing filter, so must redefine all
	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy,:download]
	before_filter :may_read_questionnaires_required, 
		:only => [:show,:index,:download]

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

protected

	def get_new
		@questionnaire = Questionnaire.new(:study_id => params[:study_id])
	end

end
