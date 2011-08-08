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
#			%w( world_region country study_name recruitment study_design target_age_group case_status subtype biospecimens ).each do |p|
			%w( world_region country study_name recruitment study_design target_age_group 
				case_control leukemiatype immunophenotype interview_respondent reference_year
				birth_year gender age ethnicity income_quint downs
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
			%w( father_age_birth mother_age_birth ).each do |p|
#	works, but I really don't like the duplication of similar faceting and filtering code
				if params[p]
					any_of do
						params[p].each do |pp|
							case pp
								when "under_20" 	#	value from row defined below
									with( p.to_sym ).less_than 20	#	NOW it is a filter	PITA duplication!
								when "20..29" 
									with( p.to_sym, 20..29 )
								when "30..39" 
									with( p.to_sym, 30..39 )
								when "40..49" 
									with( p.to_sym, 40..49 )
								when "over_50" 
									with( p.to_sym ).greater_than 50
							end
						end
					end
				end
				facet p.to_sym do
					#	row "text label for facet in view"
					row "under_20" do
						with( p.to_sym ).less_than 20		#	facet query to pre-show count if selected (NOT A FILTER)
					end
					row "20..29" do
						with( p.to_sym, 20..29 )
					end
					row "30..39" do
						with( p.to_sym, 30..39 )
					end
					row "40..49" do
						with( p.to_sym, 40..49 )
					end
					row "over_50" do
						with( p.to_sym ).greater_than 50
					end
				end
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

