class Subject < ActiveRecord::Base
	belongs_to :study

#	serialize( :biospecimens, Array )
#
#	# can't use macro style setup for after_find or after_initialize
#	def after_initialize
#		# set biospecimens default to empty Array
#		self.biospecimens = Array.new if self.biospecimens.nil?
#	end

	delegate :study_name,
		:world_region,
		:country,
		:study_design,
		:target_age_group,
		:principal_investigators,
		:recruitment, :to => :study, :allow_nil => true

	searchable do 
		integer :study_id, :references => Study
		string :study_name
		string :world_region
		string :country
		string :study_design
		string :target_age_group
		string :recruitment
		string :principal_investigators,  :multiple => true

#		integer :subid
#		string :case_status
#		string :subtype
#		string :biospecimens, :multiple => true

		string  :clic_id
		string  :case_control			#	change
		string  :leukemiatype			#	change
		string  :immunophenotype			#	change
		string  :interview_respondent
		integer :reference_year, :trie => true
		integer :birth_year, :trie => true
		string  :gender
		integer :age, :trie => true
		string  :ethnicity
		integer :mother_age_birth, :trie => true			#	change
		integer :father_age_birth, :trie => true			#	change
		string  :income_quint			#	change
		string  :downs
		string  :mother_education
		string  :father_education

		time :created_at
		time :updated_at
	end

	def to_s
#		"Subject: #{subid} : #{case_status} : #{subtype}"
		"Subject: #{clic_id} : #{case_control} : #{leukemiatype} : #{immunophenotype}"
	end
end
