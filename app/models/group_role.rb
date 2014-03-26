class GroupRole < ActiveRecord::Base

	attr_accessible :name

	acts_as_list

#	default scopes are EVIL.  They seem to take precedence
#	over you actual query which seems really stupid
#	removing all in rails 3 which will probably require
#	modifications to compensate in the methods that expected them
#	default_scope :order => :position

#	has_and_belongs_to_many :users, :uniq => true
	has_many :memberships
	has_many :users,  :through => :memberships
	has_many :groups, :through => :memberships
	validates_presence_of   :name
	validates_uniqueness_of :name
	validates_length_of     :name,  :maximum => 250

	def to_s
		name
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching name.
	def self.[](name)
#		find_by_name(name.to_s) #|| raise(NotFound)
		where(name:name.to_s).first #|| raise(NotFound)
	end

end
