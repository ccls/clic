class GroupDocumentsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_id_required,
		:only => [:edit,:update,:show,:destroy]

	before_filter :may_read_group_document_required, :only => :show

	def show
		if @group_document.document.path.blank?
			flash[:error] = "Does not contain a document"
			redirect_to :back #preview_document_path(@document)
		elsif @group_document.document.exists?
			if @group_document.document.options[:storage] == :filesystem #	&&
				#	basically development or non-s3 setup
				send_file @group_document.document.path
			else
				#	basically a private s3 file
				redirect_to @group_document.document.expiring_url
			end
		else
			flash[:error] = "Document does not exist at the expected location."
			redirect_to :back	#preview_document_path(@document)
		end
	end

protected

	def valid_id_required
		if GroupDocument.exists?(params[:id])
			@group_document = GroupDocument.find(params[:id])
		else
			access_denied("Valid group document id required")
		end
	end

	def may_read_group_document_required
		current_user.may_read_group_document?(@group_document) || access_denied
	end

end
