if g = Gem.source_index.find_name('jakewendt-simply_documents').last
require 'simply_documents'
#require g.full_gem_path + '/app/controllers/documents_controller'
#	for some reason, load works better that require in development
#	require produces the "expected to define DocumentsController"
#	even though the require should load.  Development forgets.
load g.full_gem_path + '/app/controllers/documents_controller.rb'
end

DocumentsController.class_eval do

	skip_before_filter :login_required,
		:only => [:show,:preview]
	skip_before_filter :may_maintain_pages_required,
		:only => [:show,:preview]

end
