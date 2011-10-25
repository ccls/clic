class UsersController < ApplicationController

	skip_before_filter :login_required, 
		:only => [:new, :create]
#		:only => [:new, :create, :menu]

	before_filter :no_current_user_required, :only => [:new, :create]
	before_filter :id_required, :only => [:edit, :show, :update, :approve, :destroy ]
	before_filter :may_edit_user_required,  :only => [:edit,:update]
	before_filter :may_view_user_required,  :only => [:show]
	before_filter :may_view_users_required, :only => :index
	before_filter :may_administrate_required, :only => [:approve,:destroy]

	def new	
		@user = User.new	
		@groups = Group.joinable
		@group_roles = GroupRole.all
	end	

	def create	
		@user = User.new(params[:user])	
		@user.save!
		flash[:notice] = "Registration successful. Please check your email to complete."
		@user.reset_perishable_token!
		UserMailer.deliver_new_user_email(@user) unless Rails.env == 'development'
		UserMailer.deliver_confirm_email(@user)
		redirect_to login_url	
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		@groups = Group.joinable
		@group_roles = GroupRole.all
		flash.now[:error] = 'User creation failed'
		render :action => 'new'	
	end	

	def edit
	end

	def update
		email_was = @user.email
		@user.update_attributes!(params[:user])	
		flash_notice = "Successfully updated profile."	
		if (email_was != @user.email)
			current_user_session.destroy
			@user.old_email = email_was
			@user.email_confirmed_at = nil
			@user.save!
			flash_notice << " Please check your email to complete email change."
			UserMailer.deliver_confirm_email(@user)
		end
		flash[:notice] = flash_notice
		redirect_to user_path(@user)
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		flash.now[:error] = "Update failed"
		render :action => 'edit'	
	end 

	def approve
		@user.approve!
	rescue ActiveRecord::RecordNotSaved
		flash[:error] = "User approval failed"
	ensure
		redirect_to users_path
	end

	def show
		@roles = Role.all
	end

	def index
		@users = User.search(params)
	end

	def destroy
		@user.destroy
		redirect_to users_path
	end

#	ssl_allowed :menu
#
#	def menu
#		respond_to do |format|
#			format.js {}
#		end
#	end

protected

	def id_required
		if !params[:id].blank? and User.exists?(params[:id])
			@user = User.find(params[:id])
		else
			access_denied("user id required!", users_path)
		end
	end

end
