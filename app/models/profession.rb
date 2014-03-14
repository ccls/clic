class Profession < ActiveRecord::Base


	attr_protected		#	I really shouldn't do this



#	default scopes are EVIL.  They seem to take precedence
#	over you actual query which seems really stupid
#	removing all in rails 3 which will probably require
#	modifications to compensate in the methods that expected them
#	default_scope :order => :position

	acts_as_list

	has_many :user_professions
	has_many :users, :through => :user_professions

	validates_presence_of   :name
	validates_uniqueness_of :name
	validates_length_of     :name,  :maximum => 250

	def to_s
		name
	end

	def is_other?
		name == 'Other'
	end

end
