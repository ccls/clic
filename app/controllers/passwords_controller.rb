class PasswordsController < ApplicationController

#	Other than the default login_required, there seems
#	to be no need of other filters.  This edits the
#	current_user's password, so no id needed.

	def update
		if params[:user] && 
				params[:user][:password].blank? &&
				params[:user][:password_confirmation].blank?
			flash[:warn] = "Password was NOT provided so NOT updated."
			redirect_to user_path(current_user)
		else
			current_user.update_attributes!(params[:user])
			#
			#	Changing the password resets the persistence_token, which
			#	is what is used to determine the logged in user.
			#	We need to update the session to use this new token
			#	otherwise the user will effectively be logged out here.
			#
			current_user_session.send(:update_session)
			flash[:notice] = "Password successfully updated."
			redirect_to user_path(current_user)
		end
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Password update failed."
		render :action => 'edit'
	end

end