class ApplicationController < ActionController::Base

	before_filter :login_required

	filter_parameter_logging :password, :password_confirmation

	helper :all # include all helpers, all the time
	helper_method :current_user, :logged_in?

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery 

protected	#	private #	(does it matter which or if neither?)

	#	This is a method that returns a hash containing
	#	permissions used in the before_filters as keys
	#	containing another hash with redirect_to and 
	#	message keys for special redirection.  By default,
	#	it will redirect to root_path on failure
	#	and the flash error will be a humanized
	#	version of the before_filter's name.
	def redirections
		@redirections ||= HashWithIndifferentAccess.new({
			:not_be_user => {
				:redirect_to => user_path(current_user)
			}
		})
	end

	def logged_in?
		!current_user.nil?
	end

	def current_user_required
		unless logged_in?
			redirect_to login_path
		end
	end
	alias_method :login_required, :current_user_required

	def current_user_session
		return @current_user_session if defined?(@current_user_session)
		@current_user_session ||= UserSession.find
#		@current_user_session ||= UserSession.find
	end

	def current_user
		return @current_user if defined?(@current_user)
		@current_user = current_user_session && current_user_session.user
	end

#	def current_user
#		load 'user.rb' unless defined?(User)
#		@current_user ||= if( session && session[:user_id] )
#				#	if the user model hasn't been loaded yet
#				#	this will return nil and fail.
##				User.find_create_and_update_by_uid(session[:calnetuid])
#			else
#				nil
#			end
#	end

end
class PhotosController < ApplicationController
unloadable
end
class PagesController < ApplicationController
unloadable
end
