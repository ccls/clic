class DocumentsController < ApplicationController

	before_filter :login_required, 
		:except => [:show,:preview]
	before_filter :may_maintain_pages_required, 
		:except => [:show,:preview]
	before_filter :document_required, 
		:only => :show
	before_filter :id_required, 
		:only => [ :edit, :update, :destroy, :preview ]

	def show
		if @document.document.path.blank?
			flash[:error] = "Does not contain a document"
			redirect_to preview_document_path(@document)
		elsif @document.document.exists?
			if @document.document.options[:storage] == :filesystem #	&&
				#	basically development or non-s3 setup
				send_file @document.document.path
			else
				#	basically a private s3 file
				redirect_to @document.document.expiring_url
			end
		else
			flash[:error] = "Document does not exist at the expected location."
			redirect_to preview_document_path(@document)
		end
	end

	def preview
	end

	def index
		@documents = Document.all
	end

	def new
		@document = Document.new
	end

	def create
		@document = Document.new(document_params)
		@document.save!
		redirect_to preview_document_path(@document)
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		flash.now[:error] = "Error"
		render :action => 'new'
	end

	def update
		@document.update_attributes!(document_params)
		redirect_to preview_document_path(@document)
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		flash.now[:error] = "Error"
		render :action => 'edit'
	end

	def destroy
		@document.destroy
		redirect_to documents_path
	end

protected

	def id_required
		if params[:id].present? and Document.exists?(params[:id])
			@document = Document.find(params[:id])
		else
			access_denied("Valid document id required!", documents_path)
		end
	end

	def document_required
		if params[:id].present? and Document.exists?(params[:id])
			@document = Document.find(params[:id])
		elsif params[:id].present? and Document.exists?(
				:document_file_name => "#{params[:id]}.#{params[:format]}")
			@document = Document.where(:document_file_name => "#{params[:id]}.#{params[:format]}").first
		else
			access_denied("Valid document id required!", documents_path)
		end
	end

	def document_params
		params.require(:document).permit(:title, :document, :abstract)
	end

end
