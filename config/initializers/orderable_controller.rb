#
#	Currently, used just in professions' and publication_subjects' controllers
#		primarily to dry it up.  Could also add to pages' controller and any
#		future orderable resources.  This is nice as there isn't a view.
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
			model = self.class.controller_name.camelize.singularize.constantize
#	This seems to treat params[:ids] as an array even if it is not?
			params[:ids].each_with_index { |id,index| 
				model.find(id).update_attribute(:position, index+1 ) }
		rescue NoMethodError => e
#	Most likely caused by nonexistant params[:ids]
#	e would be ...
#		You have a nil object when you didn't expect it!
#		You might have expected an instance of Array.
#		The error occurred while evaluating nil.each_with_index
			flash[:error] = "No ids passed"
		rescue ActiveRecord::RecordNotFound => e
#	e would be like "Couldn't find PublicationSubject with ID=0"
#			flash[:error] = "Ids included an invalid id:#{e}"
			flash[:error] = e.to_s
		ensure
			redirect_to :action => 'index', :parent_id => params[:parent_id]
		end

	end

end
ActionController::Base.send(:include,OrderableController)
