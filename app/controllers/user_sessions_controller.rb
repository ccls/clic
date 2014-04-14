class UserSessionsController < ApplicationController

	skip_before_filter :login_required, :only => [:new, :create]
	before_filter :no_current_user_required, :only => [:new, :create]

	def new
		@user_session = UserSession.new
	end

	def create
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
			redirect_path = session[:return_to] || root_path
			session[:return_to] = nil
			redirect_to redirect_path
		else
			@user_session.errors.delete(:username)
			@user_session.errors.delete(:password)
			flash.now[:error] = "Error logging in"
			render :action => :new
		end
	end

	def destroy
		current_user_session.destroy
		flash[:notice] = "You've been logged out"
		redirect_to root_path
	end

end
