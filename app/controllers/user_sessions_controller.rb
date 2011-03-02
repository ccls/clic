class UserSessionsController < ApplicationController

	skip_before_filter :login_required, :only => [:new, :create]
	before_filter :no_current_user_required, :only => [:new, :create]

	def new
		@user_session = UserSession.new
	end

	def create
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
			redirect_to session[:return_to]||root_path
			session[:return_to] = nil
		else
#			#	The save will add errors to the object if login
#			#	fails.  These errors will be shown on the login
#			#	page which is bad practice as it gives a would-be
#			#	hacker assistance in valid user names.
##	If I clear the errors, the brute force attack message
##	of too many failed login attempts will disappear.
##	Need to find a way to clear except ...
			@user_session.errors.delete(:username)
			@user_session.errors.delete(:password)
#			#	Remember any base error messages.
##			e = @user_session.errors.on(:base)
##			@user_session.errors.clear
##			@user_session.errors.add(:base, e) if e
			flash.now[:error] = "Error logging in"
			render :action => :new
		end
	end

	def destroy
		current_user_session.destroy
#	probably should redirect to root_path
		flash[:notice] = "You've been logged out"
		redirect_to root_path	#new_user_session_url
	end

#../../jakewendt/_OLD_AND_RENAMED_/ucb_ccls_auth_engine/app/controllers/user_sessions_controller.rb

end
class ActiveRecord::Errors
	def delete(key)
		@errors.delete(key.to_s)
	end
end
