Object.class_eval do
	def html_friendly
		self.to_s.downcase.gsub(/\W/,'_').gsub(/_+/,'_')
	end
end
