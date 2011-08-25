class InventoriesController < ApplicationController

	before_filter :may_administrate_required
	
	def show

#	TODO rename :category to just :exposure
#	TODO nest exposure facets so if remove :exposure all go away

		@exposure_search = Exposure.search do
			facet :category, :sort => :index
			if params[:category]
				with :category, params[:category]
#				%w( relation_to_child types windows assessments locations_of_use forms_of_contact ).each do |p|
				exposure_facets.each do |p|
					if params[p]
						with(p).any_of params[p]
					end
					facet p.to_sym, :sort => :index
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
#			%w( world_region country study_name recruitment study_design target_age_group 
#				case_control leukemiatype immunophenotype interview_respondent 
#				gender age ethnicity income_quint downs
#				mother_education father_education ).each do |p|
				subject_facets.each do |p|
				if params[p]
					if params[p+'_op'] && params[p+'_op']=='AND'
						with(p).all_of params[p]
					else
						with(p).any_of params[p]
					end
				end
				facet p.to_sym, :sort => :index
			end
#			%w( birth_year reference_year ).each do |p|
			year_facets.each do |p|
				range_facet_and_filter_for(p,params.dup,{:start => 1980, :stop => 2010, :step => 5})
			end
#			%w( father_age_birth mother_age_birth ).each do |p|
			age_facets.each do |p|
				range_facet_and_filter_for(p,params.dup)
			end

##	what about principle investigators?

			#
			#	if study_ids from exposure search is empty, this search bombs, but nil is ok
			#
			if params[:category] 
				if study_ids.empty?
					with( :study_id, nil )
				else
					with( :study_id ).any_of( study_ids )
				end
			end
			facet :study_id

			order_by :created_at, :asc
			paginate :page => params[:page]
		end
		studies = @search.facet(:study_id).rows.collect(&:instance)
		@questionnaires = studies.collect(&:questionnaires).flatten
	end	#	show action

protected

	def exposure_facets
		%w( relation_to_child types windows assessments locations_of_use forms_of_contact )
	end

	def subject_facets
		%w( world_region country study_name recruitment study_design target_age_group case_control leukemiatype immunophenotype interview_respondent gender age ethnicity income_quint downs mother_education father_education )
	end

	def year_facets
		%w( birth_year reference_year )
	end

	def age_facets
		%w( father_age_birth mother_age_birth )
	end

end

#	This isn't really a view helper, so I removed it from the helpers
#	and put it here where it is actually used.
Sunspot::DSL::Search.class_eval do
	#
	#	Add options to control
	#		under = nil   (-infinity)   boolean to flag under start???
	#		over  = nil   (infinity)    boolean to flag over stop???
	#		start = 20
	#		step  = 10
	#		end   = 50
	#
#
#	TODO change "Under 20" to "20 and under"
#	TODO change "Over 50"  to "50 and over"
#
	def range_facet_and_filter_for(field,params={},options={})
		start = (options[:start] || 20).to_i
		stop  = (options[:stop]  || 50).to_i
		step  = (options[:step]  || 10).to_i
		if params[field]
			any_of do
				params[field].each do |pp|
					if pp =~ /^Under (\d+)$/
						with( field.to_sym ).less_than $1     #	actually less than or equal to
					elsif pp =~ /^Over (\d+)$/
						with( field.to_sym ).greater_than $1  #	actually greater than or equal to
					elsif pp =~ /^\d+\.\.\d+$/
						with( field.to_sym, eval(pp) )
					elsif pp =~ /^\d+$/
						with( field.to_sym, pp )	#	primarily for testing?  No range, just value
					end
				end
			end
		end
		facet field.to_sym do
			#	row "text label for facet in view", block for facet.query
			row "Under #{start}" do
				#	Is less_than just less_than or does it also include equal_to?
				#	Results appear to include equal_to which makes it actually incorrect and misleading.
				with( field.to_sym ).less_than start		#	facet query to pre-show count if selected (NOT A FILTER)
			end
			(start..(stop-step)).step(step).each do |range|
				row "#{range}..#{range+step}" do
					with( field.to_sym, Range.new(range,range+step) )
				end
			end
			row "Over #{stop}" do
				#	Is greater_than just greater_than or does it also include equal_to?
				#	Results appear to include equal_to which makes it actually incorrect and misleading.
				with( field.to_sym ).greater_than stop
			end
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

