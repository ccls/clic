class DocFormsController < ApplicationController

	layout 'members_onlies'

	resourceful

	def create
		@doc_form = DocForm.new(params[:doc_form])
		@doc_form.current_user = current_user
		@doc_form.save!
		flash[:notice] = "Success!"
		redirect_to @doc_form
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "something bad happened"
		render :action => 'new'
	end

end
