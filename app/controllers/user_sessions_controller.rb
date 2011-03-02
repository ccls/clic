class UserSessionsController < ApplicationController

	skip_before_filter :login_required, :only => [:new, :create]

	def new
		@user_session = UserSession.new
	end

	def create
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
			redirect_to root_path
#	should really remember where the user was going and redirect there
		else
			render :action => :new
		end
	end

	def destroy
		current_user_session.destroy
#	probably should redirect to root_path
		redirect_to new_user_session_url
	end

#../../jakewendt/_OLD_AND_RENAMED_/ucb_ccls_auth_engine/app/controllers/user_sessions_controller.rb

end
