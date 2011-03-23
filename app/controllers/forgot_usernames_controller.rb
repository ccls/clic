class ForgotUsernamesController < ApplicationController
	skip_before_filter :login_required
	before_filter   :no_login_required

	def create
		@user = User.find_by_email(params[:email])  
		if @user  
			flash[:notice] = "A user was found matching that email address. " <<
				"Please find the username below."  
		else  
			flash.now[:error] = "No user was found with that email address"  
			render :action => :new  
		end  
	end


end
