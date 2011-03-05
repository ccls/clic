class UsersController < ApplicationController

	skip_before_filter :login_required, 
		:only => [:new, :create, :menu]

	before_filter :no_current_user_required, :only => [:new, :create]
	before_filter :id_required, :only => [:edit, :show, :update ]
	before_filter :may_view_user_required, :only => [:edit,:update,:show]
	before_filter :may_view_users_required, :only => :index

	def new	
		@user = User.new	
	end	

	def create	
		@user = User.new(params[:user])	
		@user.save!
		flash[:notice] = "Registration successful."	
		redirect_to login_url	
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		flash.now[:error] = 'User creation failed'
		render :action => 'new'	
	end	

	def edit
	end

	def update	
		@user.update_attributes!(params[:user])	
		flash[:notice] = "Successfully updated profile."	
		redirect_to root_url	
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		flash.now[:error] = "Update failed"
		render :action => 'edit'	
	end 

	def show
		@roles = Role.all
	end

	def index
		@users = User.search(params)
	end

	ssl_allowed :menu

	def menu
		respond_to do |format|
			format.js {}
		end
	end

protected

	def id_required
		if !params[:id].blank? and User.exists?(params[:id])
			@user = User.find(params[:id])
		else
			access_denied("user id required!", users_path)
		end
	end

end
