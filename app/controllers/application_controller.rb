#
#	In development mode, rails will "forget" things which can
#	lead to errors like ....
#
#Processing DocumentsController#index (for 169.229.196.197 at 2011-03-03 09:32:58) [GET]
#  Parameters: {"action"=>"index", "controller"=>"documents"}
#
#ArgumentError (A copy of ApplicationController has been removed from the module tree but is still active!):
#  app/controllers/application_controller.rb:55:in `current_user_session'
#  app/controllers/application_controller.rb:59:in `current_user'
#  app/controllers/application_controller.rb:31:in `logged_in?'
#  app/controllers/application_controller.rb:63:in `login_required'
#
#Rendered rescues/_trace (26.3ms)
#Rendered rescues/_request_and_response (0.4ms)
#Rendering rescues/layout (internal_server_error)
#
#	There are many ways to deal with this like adding "unloadable"
#	to those things that get "forgotten", but that has been deemed
#	deprecated.  Adding ....
#
require __FILE__
#
#	... also seems to "fix" this.  I've tried putting it at the
#	bottom so that it was out of the way, but no joy.
#
#	I don't quite understand why this happens (as I've seen it before)
#
class ApplicationController < ActionController::Base

	before_filter :login_required

	filter_parameter_logging :password, :password_confirmation, :current_password

	helper :all # include all helpers, all the time
	helper_method :current_user_session, :current_user, :logged_in?

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery 

protected	#	private #	(does it matter which or if neither?)

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

end
