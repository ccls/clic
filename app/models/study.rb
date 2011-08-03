class Study < ActiveRecord::Base
	acts_as_list

	has_many :publications
	has_many :subjects

	serialize( :principal_investigators, Array )

	# can't use macro style setup for after_find or after_initialize
	def after_initialize
		# set principal_investigators default to empty Array
		self.principal_investigators = Array.new if self.principal_investigators.nil?
	end

	validates_presence_of   :name
	validates_uniqueness_of :name
	validates_length_of     :name, :maximum => 250
	validates_length_of     :world_region, :maximum => 250, :allow_nil => true
	validates_length_of     :country, :maximum => 250, :allow_nil => true
	validates_length_of     :design, :maximum => 250, :allow_nil => true
	validates_length_of     :recruitment, :maximum => 250, :allow_nil => true
	validates_length_of     :target_age_group, :maximum => 250, :allow_nil => true
	validates_length_of     :overview, :maximum => 65000, :allow_nil => true

	def to_s
		name
	end

	def study_name
		name
	end

	def study_design
		design
	end

#	searchable do
#		string :name
#	end

end
