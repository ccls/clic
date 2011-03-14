class GroupDocumentsController < ApplicationController

	layout 'members_onlies'

	before_filter :valid_group_id_required
	before_filter :valid_id_required,
		:only => [:edit,:update,:show,:destroy]
	before_filter :document_group_required,
		:only => [:edit,:update,:show,:destroy]

	before_filter "may_create_group_documents_required",  :only => [:new,:create]
	before_filter "may_read_group_documents_required",    :only => [:index,:show]
	before_filter "may_update_group_documents_required",  :only => [:edit,:update]
	before_filter "may_destroy_group_documents_required", :only => [:destroy]

	def index
		@documents = @group.documents
	end

	def new
		@document = @group.documents.new
	end

	def create
		@document = @group.documents.new(params[:document].merge(
			:user_id => current_user.id))
		@document.save!
		flash[:notice] = "Group Document created."
		redirect_to group_path(@document.group)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash[:error] = "Something bad happened"
		render :action => 'new'
	end

	def show
	end

	def edit
	end

	def update
		@document.update_attributes!(params[:document])
		flash[:notice] = 'Success!'
		redirect_to group_path(@document.group)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the document"
		render :action => "edit"
	end

	def destroy
		@document.destroy
		redirect_to group_path(@document.group)
	end

protected

	#	double check that the :group_id in the route
	#	and the group_id attribute are the same
	def document_group_required
		( @group == @document.group ) || access_denied(
			"Group Mismatch",members_only_path)
	end

	def valid_id_required
		if GroupDocument.exists?(params[:id])
			@document = GroupDocument.find(params[:id])
		else
			access_denied("Valid document id required",members_only_path)
		end
	end

	def may_create_group_documents_required
		current_user.may_create_group_documents?(@group) || access_denied
	end

	def may_read_group_documents_required
		current_user.may_read_group_documents?(@group) || access_denied
	end

	def may_update_group_documents_required
		current_user.may_update_group_documents?(@group) || access_denied
	end

	def may_destroy_group_documents_required
		current_user.may_destroy_group_documents?(@group) || access_denied
	end

end
