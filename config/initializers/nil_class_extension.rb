module NilClassExtension	#	:nodoc:
#	def self.included(base)
#		base.instance_eval do
#			include InstanceMethods
#		end
#	end
#
#	module InstanceMethods
#
#		#	Return an empty array when attempting to split nil
#		def split(*args)
#			[]
#		end
#
#		def include?(*args)
#			false
#		end
#
#	end
#
end
NilClass.send( :include, NilClassExtension )
