class DocFormsController < ApplicationController

	resourceful

	def create
		@doc_form = DocForm.new(params[:doc_form])
		@doc_form.current_user = current_user
		@doc_form.save!
		flash[:notice] = "Success!"
		redirect_to @doc_form
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Doc Form Creation Failed."
		render :action => 'new'
	end

	#
	#	doc_forms are not associated with a user (no user_id)
	#	so even on updates, if a group_document is added, the current_user
	#	must be passed to it so that it can be added to the group_documents
	#
	def update
		@doc_form.update_attributes(params[:doc_form])
		@doc_form.current_user = current_user if @doc_form.current_user.nil?
		@doc_form.save!
		flash[:notice] = 'Success!'
		redirect_to doc_forms_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the doc_form"
		render :action => "edit"
	end

end
