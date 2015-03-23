class GroupRole < ActiveRecord::Base

	acts_as_list

	has_many :memberships
	has_many :users,  :through => :memberships
	has_many :groups, :through => :memberships

	validations_from_yaml_file

	def to_s
		name
	end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching name.
	def self.[](name)
		where(name:name.to_s).first
	end

end
