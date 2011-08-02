class InventoriesController < ApplicationController

	before_filter :may_administrate_required
	
	def show
		@search = Subject.search do
			keywords params[:q]
#	undefined method `name' for "Book":String 
#	where Book is params[:class]
#	either constantize or create String#name method
#	both seem to make Sunspot happy
#			with(:class, params[:class].constantize) if params[:class]
#			facet :class 

#	facet order is preserved, so the order it is listed here
#		will be the order that it is presented in the view

#
#	genotypings not desired at the moment.  When it is, just add to the list after biospecimens
#	principal_investigators
#
			%w( world_region country study_name recruitment study_design target_age_group case_status subtype biospecimens ).each do |p|
				if params[p]
					if params[p+'_op'] && params[p+'_op']=='AND'
						with(p).all_of params[p]
					else
						with(p).any_of params[p]
					end
				end
				facet p.to_sym
			end

##	what about principle investigators?

			with( :study_id ).any_of( study_ids ) if params[:category]
			facet :study_id

			order_by :created_at, :asc
			paginate :page => params[:page]
		end
	end

end
