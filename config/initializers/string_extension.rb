#String.class_eval do
#	def html_friendly
#		self.downcase.gsub(/\W/,'_').gsub(/_+/,'_')
#	end
#end

module StringExtension	#	:nodoc:
#	def self.included(base)
#		base.instance_eval do
#			include InstanceMethods
#		end
#	end
#
#  module InstanceMethods
#
#		#	Convert a query string like that in a URL
#		#	to a Hash
#		def to_params_hash
#			h = HashWithIndifferentAccess.new
#			self.split('&').each do |p|
#				(k,v) = p.split('=',2)
#				h[k] = URI.decode(v)
#			end
#			return h
#		end
#
#		#	Return self
#		def uniq
#			self
#		end
#
#  end
#
end
String.send( :include, StringExtension )
