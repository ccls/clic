class PasswordResetsController < ApplicationController

	skip_before_filter :login_required
	before_filter   :no_login_required

	before_filter :load_user_using_perishable_token, :only => [:edit, :update]  

	def create
		@user = User.find_by_email(params[:email])  
		if @user  
			@user.reset_perishable_token!
			UserMailer.forgot_password(@user).deliver
			flash[:notice] = "Instructions to reset your password have been emailed to you. " <<
				"Please check your email."  
			redirect_to root_url  
		else  
			flash.now[:error] = "No user was found with that email address"  
			render :action => :new  
		end  
	end

	def update

#
#	If the user is not valid due to validations added
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
#			@user.password = params[:user][:password]
#			@user.password_confirmation = params[:user][:password_confirmation]
#			@user.save!(false) 
#	no. save! doesn't take arguments
#	and save(false) won't raise errors
#	if doing this, will need to do something other that rescue
#			@user.save(false)
#
#	in rails 2 I think
#	In rails 3, it is save(:validate => false).
#
#

		@user.update_attributes!(params[:user])



		flash[:notice] = "Password successfully updated"
		redirect_to login_path
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Update failed"
		render :action => 'edit'
	end

protected

	def load_user_using_perishable_token  
		@user = User.find_using_perishable_token(params[:id])  
		unless @user  
			flash[:error] = "We're sorry, but we could not locate your account. " <<
				"If you are having issues try copying and pasting the URL " <<
				"from your email into your browser or restarting the " <<
				"reset password process."  
			redirect_to root_path
		end  
	end

end
