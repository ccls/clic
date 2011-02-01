#	The search controller
class SearchResultsController < ApplicationController

	skip_before_filter :login_required

#	ssl_allowed :index
#	ssl_denied  :index		<-- create this to force http

end
