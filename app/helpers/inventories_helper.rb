module InventoriesHelper
end

Sunspot::DSL::FieldQuery.class_eval do

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
						with( field.to_sym ).less_than $1
					elsif pp =~ /^Over (\d+)$/
						with( field.to_sym ).greater_than $1
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
