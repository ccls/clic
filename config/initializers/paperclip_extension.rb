Paperclip::ClassMethods.class_eval do

	def has_attached_file_with_file_name_transliteration(name,options={})

		#	make the normal call to paperclip
		has_attached_file_without_file_name_transliteration(name,options)

		#	add a specific post processor for this attachment
		send("before_#{name}_post_process", "transliterate_file_name_for_#{name}")

		#	define the post processor
		define_method "transliterate_file_name_for_#{name}" do
			filename = self.send(name).instance_read(:file_name)
			extension = File.extname(filename)
			basename  = File.basename(filename, extension)
			extension.gsub!(/^\./,'')	#	remove the leading . from the extension
			self.send(name).instance_write(:file_name,
				"#{basename.transliterate}.#{extension.transliterate}")
		end

	end
	alias_method_chain :has_attached_file, :file_name_transliteration

end

String.class_eval do
	def transliterate
		s = self.dup
		s.gsub!(/'/,'')     #	remove apostrophes altogether
		s.gsub!(/\W+/,'_')  #	replace all non-alphanumerics with underscores
		s
	end
end

#	based loosely on ...
#	http://www.davesouth.org/stories/make-url-friendly-filenames-in-paperclip-attachments
