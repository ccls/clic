class PublicationSubject < ActiveRecord::Base

	attr_accessible :name

	acts_as_list

	has_many :publication_publication_subjects
	has_many :publications, :through => :publication_publication_subjects

	validations_from_yaml_file

	def to_s
		name
	end

	def is_other?
		name == 'Other'
	end

end
