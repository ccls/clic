class Profession < ActiveRecord::Base

	attr_accessible :name

	acts_as_list

	has_many :user_professions
	has_many :users, :through => :user_professions

	validations_from_yaml_file

	def to_s
		name
	end

	def is_other?
		name == 'Other'
	end

end
