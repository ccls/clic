#
#	Currently, used just in professions' and publication_subjects' controllers
#		primarily to dry it up.  Could also add to pages' controller and any
#		future orderable resources.  This is nice as there isn't a view.
#	Need to do something similar in javascript as the 3 orderable resources
#		each have very similar javascripts.
#
module OrderableController

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def orderable
#
#	I would prefer a more unique filter specific to the resource.
#	Must be careful not to interfere with existing before_filters
#		particularly of the same name for different actions as it
#		seems that before_filter will overwrite rather than append.
#
			before_filter :may_administrate_required, :only => :order
			include OrderableController::Actions
		end

	end

	module Actions

		def order
#	If generalize javascript, the passed param will be something
#		like just "ids" rather than the model.
			param = self.class.controller_name	#	publication_subjects

			if params[param] && params[param].is_a?(Array)
				params[param].each_with_index { |id,index| 
					param.camelize.singularize.constantize.find(id).update_attribute(:position, index+1 ) }
			else
				flash[:error] = "No #{param} order given!"
			end
			redirect_to :action => 'index'
		end

	end

end
ActionController::Base.send(:include,OrderableController)
