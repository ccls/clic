
	#	As this app is in a subdir in production,
	#	Rails sets the ActionController::Base.relative_url_root
	#	to its value of "/clic".
	#	Since we are actually accessing the site via
	#	a proxy where it is acting like root,
	#	we need to undo that.

##	Don't think this does anything either.
#ActionController::Base.relative_url_root = ''
#class ActionController::Base
#	def relative_url_root
#		''
#	end
#	#	not sure which of these I need.
#	#	I can't seem to stop if from being set,
#	#	but I can stop it from being read!
#	def self.relative_url_root
#		''
#	end
##	doesn't seem to do as expected
##	def self.default_url_options(options)
##		{ :skip_relative_url_root => true }
##	end
#end


class ApplicationController < ActionController::Base

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery 

protected	#	private #	(does it matter which or if neither?)

	#	from ucb_ccls_engine_controller.rb 
	#skip_before_filter :build_menu_js
	#	The before filter is defined too late,
	#	but we can redefine the method!
	def build_menu_js
	end

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

#	def block_all_access
#		access_denied("That route is no longer available")
#	end

end
