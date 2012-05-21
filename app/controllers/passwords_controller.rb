class PasswordsController < ApplicationController

#	Other than the default login_required, there seems
#	to be no need of other filters.  This edits the
#	current_user's password, so no id needed.

	before_filter :validate_current_password, :only => :update

	def update
		if params[:user] && 
				params[:user][:password].blank? &&
				params[:user][:password_confirmation].blank?
			flash[:warn] = "Password was NOT provided so NOT updated."
			redirect_to user_path(current_user)
		else


#
#	If the current user is not valid due to validations added
#	after the last time the user was updated, this will
#	raise these errors and not allow the user to save the new
#	password.  This should probably be set to just update
#	the password and password_confirmation and then
#	save without validating.  
#
#	Skipping the validations will probably skip the 
#	comparison of the password to password_confirmation
#	so probably want to find a better way!!!!
#
#			current_user = params[:user][:password]
#			current_user = params[:user][:password_confirmation]
#			current_user.save!(false) 
#	no. save! doesn't take arguments
#	and save(false) won't raise errors
#	if doing this, will need to do something other that rescue
#			current_user.save(false)
#
#	in rails 2 I think
#	In rails 3, it is save(:validate => false).
#
#
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

protected

	def validate_current_password
		access_denied("Old password is not valid",edit_password_path) unless
			current_user.valid_password?(params[:user].delete('current_password'))
	end

end
