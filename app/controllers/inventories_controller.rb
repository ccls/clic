class InventoriesController < ApplicationController
#
##	NOTE	Sunspot searching for blank facet values.
##		Searching for '' is not possible and searching for nil
##		A value that is '' will create a facet this is '', but 
##			is not searchable.  PERIOD.  There MAY be a way to do
##			this, but I have not found it.  The '' creates a 
##			search statement that is syntactically incorrect.
##		Nil, however, is searchable, but not as a value in a
##			any_of or all_of array.  It would have to be explicitly
##			parsed out of the param array and explicitly checked for.
##		Due to these restrictions, I am skipping all blank facet
##			values in the view and ignoring them in this controller
##			as a user may manually modify the url.
#
#	before_filter :may_read_inventory_required
#	
#	def show
#
##	TODO rename :category to just :exposure
##	TODO nest exposure facets so if remove :exposure all go away
##	or just params.delete( all of the exposure keys )
#
#		@exposure_search = Exposure.search do
#			facet :category, :sort => :index
#			if params[:category]
#				with :category, params[:category]
#				exposure_facets.each do |p|
#					if params[p]
#						params[p] = params[p].dup.reject{|x|x.blank?}
#						unless params[p].empty?
#							with(p).any_of params[p]
#						else
#							params.delete(p)	#	remove the key so doesn't show in view
#						end
#					end
#					facet p.to_sym, :sort => :index
#				end
#			end
#			facet :study_id
#		end
#		#		get the study_ids from the exposure search
#		#		as pass them on to the Subject search.
#		study_ids = @exposure_search.facet(:study_id).rows.collect(&:value)
#
#		@search = Subject.search do
#			keywords params[:q]
#			#	undefined method `name' for "Book":String 
#			#	where Book is params[:class]
#			#	either constantize or create String#name method
#			#	both seem to make Sunspot happy
#			#			with(:class, params[:class].constantize) if params[:class]
#			#			facet :class 
#
#			#	facet order is preserved, so the order it is listed here
#			#		will be the order that it is presented in the view
#
##
##	genotypings not desired at the moment.  When it is, just add to the list after biospecimens
##	principal_investigators
##
#
##			subject_facets.each do |p|
##				if params[p]
##					params[p] = params[p].dup.reject{|x|x.blank?}
##					if params[p+'_op'] && params[p+'_op']=='AND'
##						unless params[p].empty?
##							with(p).all_of params[p]
##						else
##							params.delete(p)	#	remove the key so doesn't show in view
##						end
##					else
##						unless params[p].empty?
##							with(p).any_of params[p]
##						else
##							params.delete(p)	#	remove the key so doesn't show in view
##						end
##					end
##				end
##				facet p.to_sym, :sort => :index
##			end
##
##			year_facets.each do |p|
##				range_facet_and_filter_for(p,params.dup,{:start => 1980, :stop => 2010, :step => 5})
##			end
##
##			age_facets.each do |p|
##				if %w( age ).include?(p)
##					range_facet_and_filter_for(p,params.dup,:start => 1, :step => 2)
##				else
##					range_facet_and_filter_for(p,params.dup)
##				end
##			end
#
#			all_subject_facets.each do |p|
#				if child_age_facets.include?(p)
#					range_facet_and_filter_for(p,params.dup,:start => 1, :step => 2)
#				elsif parent_age_facets.include?(p)
#					range_facet_and_filter_for(p,params.dup)
#				elsif year_facets.include?(p)
#					range_facet_and_filter_for(p,params.dup,{:start => 1980, :stop => 2010, :step => 5})
#				else
#					if params[p]
#						params[p] = params[p].dup.reject{|x|x.blank?}
#						if params[p+'_op'] && params[p+'_op']=='AND'
#							unless params[p].empty?
#								with(p).all_of params[p]
#							else
#								params.delete(p)	#	remove the key so doesn't show in view
#							end
#						else
#							unless params[p].empty?
#								with(p).any_of params[p]
#							else
#								params.delete(p)	#	remove the key so doesn't show in view
#							end
#						end
#					end
#					facet p.to_sym, :sort => :index
#				end
#			end
#
#			#
#			#	if study_ids from exposure search is empty, this search bombs, but nil is ok
#			#
#			if params[:category] 
#				if study_ids.empty?
#					with( :study_id, nil )
#				else
#					with( :study_id ).any_of( study_ids )
#				end
#			end
#			facet :study_id
#
#			order_by :created_at, :asc
#			paginate :page => params[:page]
#		end
#		studies = @search.facet(:study_id).rows.collect(&:instance)
#		@questionnaires = studies.collect(&:questionnaires).flatten
#
#		#	I'm not particularly proud of this, but there was a bit of a rush.
#		#	There should always be at least one study, however.
#		if studies.empty?
#			@publications = []
#		else
#			conditions = [[]]
#			joins = []
##	Sqlite3 quoting doesn't work on MySQL
##			joins << 'LEFT JOIN "publication_studies" ON ("publications"."id" = "publication_studies"."publication_id")'
##			joins << 'LEFT JOIN "studies" ON ("studies"."id" = "publication_studies"."study_id")'
#			joins << 'LEFT JOIN publication_studies ON (publications.id = publication_studies.publication_id)'
#			joins << 'LEFT JOIN studies ON (studies.id = publication_studies.study_id)'
#			conditions[0] << 'studies.id IN (?)'
#			conditions << studies.collect(&:id)
#			if params[:category] and !params[:category].blank?
##	Sqlite3 quoting doesn't work on MySQL
##				joins << 'LEFT JOIN "publication_publication_subjects" ON ("publications"."id" = "publication_publication_subjects"."publication_id")'
##				joins << 'LEFT JOIN "publication_subjects" ON ("publication_subjects"."id" = "publication_publication_subjects"."publication_subject_id")'
#				joins << 'LEFT JOIN publication_publication_subjects ON (publications.id = publication_publication_subjects.publication_id)'
#				joins << 'LEFT JOIN publication_subjects ON (publication_subjects.id = publication_publication_subjects.publication_subject_id)'
#				conditions[0] << 'publication_subjects.name = ?'
#				conditions << params[:category]
#			end
#			conditions[0] = conditions[0].join(' AND ')
#			@publications = Publication.find(:all,
#				:select     => 'DISTINCT publications.*',
#				:conditions => conditions,
#				:joins      => joins )
#		end
#	rescue Errno::ECONNREFUSED
#		flash[:error] = "Solr seems to be down for the moment."
#		redirect_to root_path
#	end	#	show action
#
#protected
#
#	def all_subject_facets
#		%w( case_status leukemia_type immunophenotype gender age ethnicity birth_year reference_year mother_age father_age mother_education father_education household_income down_syndrome study_name country recruitment study_design )
#	end
#
#	def exposure_facets
##		%w( relation_to_child types windows assessments locations_of_use forms_of_contact )
#		%w( relation_to_child types windows locations_of_use forms_of_contact )
#	end
#
##	def subject_facets
###		%w( study_name country recruitment study_design case_control leukemiatype immunophenotype gender ethnicity mother_education father_education income_quint downs )
##		%w( study_name country recruitment study_design case_status leukemia_type immunophenotype gender ethnicity mother_education father_education household_income down_syndrome )
##	end
#
#	def year_facets
#		%w( birth_year reference_year )
#	end
#
#	def child_age_facets
#		%w( age )
#	end
#
#	def parent_age_facets
##		%w( age father_age_birth mother_age_birth )
##		%w( age father_age mother_age )
#		%w( father_age mother_age )
#	end
#
#	def may_read_inventory_required
#		current_user.may_read_inventory? || access_denied(
#			"Coordination Group membership required to access the inventory. Request membership now?", new_group_membership_path(Group.find_by_name('Coordination Group'))
#		)
#	end
#
#end
#
##	This isn't really a view helper, so I removed it from the helpers
##	and put it here where it is actually used.
#Sunspot::DSL::Search.class_eval do
#	#
#	#	Add options to control
#	#		under = nil   (-infinity)   boolean to flag under start???
#	#		over  = nil   (infinity)    boolean to flag over stop???
#	#		start = 20
#	#		step  = 10
#	#		end   = 50
#	#
##
##	TODO change "Under 20" to "20 and under"
##	TODO change "Over 50"  to "50 and over"
##
#	def range_facet_and_filter_for(field,params={},options={})
#		start = (options[:start] || 20).to_i
#		stop  = (options[:stop]  || 50).to_i
#		step  = (options[:step]  || 10).to_i
#		if params[field]
#			any_of do
#				params[field].each do |pp|
#					if pp =~ /^Under (\d+)$/
#						with( field.to_sym ).less_than $1     #	actually less than or equal to
#					elsif pp =~ /^Over (\d+)$/
#						with( field.to_sym ).greater_than $1  #	actually greater than or equal to
#					elsif pp =~ /^\d+\.\.\d+$/
#						with( field.to_sym, eval(pp) )
#					elsif pp =~ /^\d+$/
#						with( field.to_sym, pp )	#	primarily for testing?  No range, just value
#					end
#				end
#			end
#		end
#		facet field.to_sym do
#			#	row "text label for facet in view", block for facet.query
#			row "Under #{start}" do
#				#	Is less_than just less_than or does it also include equal_to?
#				#	Results appear to include equal_to which makes it actually incorrect and misleading.
#				with( field.to_sym ).less_than start		#	facet query to pre-show count if selected (NOT A FILTER)
#			end
#			(start..(stop-step)).step(step).each do |range|
#				row "#{range}..#{range+step}" do
#					with( field.to_sym, Range.new(range,range+step) )
#				end
#			end
#			row "Over #{stop}" do
#				#	Is greater_than just greater_than or does it also include equal_to?
#				#	Results appear to include equal_to which makes it actually incorrect and misleading.
#				with( field.to_sym ).greater_than stop
#			end
#		end
#	end
#
end
