require 'method_missing_with_authorization'
class ApplicationController < ActionController::Base
	include MethodMissingWithAuthorization

	before_filter :login_required

#	filter_parameter_logging :password, :password_confirmation, :current_password

	helper :all # include all helpers, all the time
	helper_method :current_user_session, :current_user, :logged_in?

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery 

protected	#	private #	(does it matter which or if neither?)

	def redirect_to_referer_or_default(default)
		redirect_to( session[:refer_to] || 
			request.env["HTTP_REFERER"] || default )
		session[:refer_to] = nil
	end

	#	Flash error message and redirect
	def access_denied( 
			message="You don't have permission to complete that action.", 
			default=root_path )
		session[:return_to] = request.url unless params[:format] == 'js'
		flash[:error] = message
		redirect_to default
	end

	#	used in roles_controller
	def may_not_be_user_required
		current_user.may_not_be_user?(@user) || access_denied(
			"You may not be this user to do this", user_path(current_user))
	end

	def logged_in?
		!current_user.nil?
	end

	def current_user_session
		@current_user_session ||= UserSession.find	
	end	
	
	def current_user	
		@current_user ||= current_user_session && current_user_session.record	
	end	

	def current_user_required
		logged_in? || 
			access_denied("You must be logged in to do that",login_path)
	end
	alias_method :login_required, :current_user_required

	def no_current_user_required
		logged_in? &&
			access_denied("You must be logged out to do that",root_path)
	end
	alias_method :no_login_required, :no_current_user_required

	def valid_group_id_required
		if Group.exists?(params[:group_id])
			@group = Group.find(params[:group_id])
		else
			access_denied("Valid group_id required",members_only_path)
		end
	end

	def record_or_recall_sort_order
		%w( dir order ).map(&:to_sym).each do |param|
			if params[param].blank? && !session[param].blank?
				params[param] = session[param]	#	recall
			elsif params[param].present?
				session[param] = params[param]	#	record
			end
		end
	end
	alias_method :recall_or_record_sort_order, :record_or_recall_sort_order

end
