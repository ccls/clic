class String

	def to_html_document
		#	pre rails 4.2.0
		HTML::Document.new( self ).root
		#	rails 4.2.0
		#Nokogiri::HTML::DocumentFragment.parse( self )
	end

end	
