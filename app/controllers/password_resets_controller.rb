class PasswordResetsController < ApplicationController

	skip_before_filter :login_required
	before_filter   :no_login_required

	before_filter :load_user_using_perishable_token, :only => [:edit, :update]  

	def create
		@user = User.find_by_email(params[:email])  
		if @user  
			@user.reset_perishable_token!
			UserMailer.deliver_forgot_password(@user)
			flash[:notice] = "Instructions to reset your password have been emailed to you. " <<
				"Please check your email."  
			redirect_to root_url  
		else  
			flash.now[:error] = "No user was found with that email address"  
			render :action => :new  
		end  
	end

	def update
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
