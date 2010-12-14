if g = Gem.source_index.find_name('jakewendt-simply_documents').last
require 'simply_documents'
require g.full_gem_path + '/app/controllers/documents_controller'
end

DocumentsController.class_eval do

	skip_before_filter :may_maintain_pages_required,
		:only => [:show,:preview]

end
