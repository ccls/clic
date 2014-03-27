class Study < ActiveRecord::Base

	acts_as_list

	has_many :publication_studies
	has_many :publications, :through => :publication_studies
	has_many :subjects
	has_many :exposures
	has_many :questionnaires

	attr_protected :principal_investigators
	attr_writer :principal_investigator_names
	before_save :parse_principal_investigator_names

	serialize( :principal_investigators, Array )

#	# can't use macro style setup for after_find or after_initialize
#	def after_initialize
#		# set principal_investigators default to empty Array
#		self.principal_investigators = Array.new if self.principal_investigators.nil?
#	end

	validations_from_yaml_file

	def to_s
		name
	end

	def study_name=(new_name)
		self.name = new_name
	end

	def study_name
		name
	end

	def study_design=(new_design)
		self.design = new_design
	end

	def study_design
		design
	end

	def principal_investigator_names
		principal_investigators.join(', ')
	end

protected

	def parse_principal_investigator_names
		unless @principal_investigator_names.blank?
			self.principal_investigators = @principal_investigator_names.split(',').collect(&:strip).reject{|n|n.blank?}
		end
	end

end
