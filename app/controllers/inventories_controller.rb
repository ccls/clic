class InventoriesController < ApplicationController

	before_filter :may_administrate_required
	
	def show

		@exposure_search = Exposure.search do
			facet :category
			if params[:category]
				with :category, params[:category]
				%w( relation_to_child types windows assessments locations_of_use forms_of_contact ).each do |p|
					if params[p]
						with(p).any_of params[p]
					end
					facet p.to_sym
				end
			end
			facet :study_id
		end
		study_ids = @exposure_search.facet(:study_id).rows.collect(&:value)

#		get the study_ids from the exposure search
#		as pass them on to the Subject search.




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
#			%w( world_region country study_name recruitment study_design target_age_group case_status subtype biospecimens ).each do |p|
			%w( world_region country study_name recruitment study_design target_age_group 
				case_control leukemiatype immunophenotype interview_respondent 
				gender age ethnicity income_quint downs
				mother_education father_education ).each do |p|
				if params[p]
					if params[p+'_op'] && params[p+'_op']=='AND'
						with(p).all_of params[p]
					else
						with(p).any_of params[p]
					end
				end
				facet p.to_sym, :sort => :index
			end
			%w( birth_year reference_year ).each do |p|
				range_facet_and_filter_for(p,params.dup,{:start => 1980, :stop => 2010, :step => 5})
			end
			%w( father_age_birth mother_age_birth ).each do |p|
				range_facet_and_filter_for(p,params.dup)
			end

##	what about principle investigators?

			with( :study_id ).any_of( study_ids ) if params[:category]
			facet :study_id

			order_by :created_at, :asc
			paginate :page => params[:page]
		end
	end

end

__END__

			t.string  :clic_id
			t.string  :case_control
			t.string  :leukemiatype
			t.string  :immunophenotype
			t.string  :interview_respondent
			t.integer :reference_year
			t.integer :birth_year
			t.string  :gender
			t.integer :age
			t.string  :ethnicity
			t.integer :mother_age_birth
			t.integer :father_age_birth
			t.string  :income_quint
			t.string  :downs
			t.string  :mother_education
			t.string  :father_education

