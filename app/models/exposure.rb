class Exposure < ActiveRecord::Base
	belongs_to :study

	serialize( :types, Array )
	serialize( :windows, Array )
	serialize( :assessments, Array )
	serialize( :forms_of_contact, Array )
	serialize( :locations_of_use, Array )

	# can't use macro style setup for after_find or after_initialize
	def after_initialize
		# set types default to empty Array
		self.types = Array.new if self.types.nil?
		# set windows default to empty Array
		self.windows = Array.new if self.windows.nil?
		# set assessments default to empty Array
		self.assessments = Array.new if self.assessments.nil?
		# set forms_of_contact default to empty Array
		self.forms_of_contact = Array.new if self.forms_of_contact.nil?
		# set locations_of_use default to empty Array
		self.locations_of_use = Array.new if self.locations_of_use.nil?
	end

#	searchable do 
#		integer :study_id, :references => Study
#		string :category
#		string :relation_to_child
#		string :types, :multiple => true
#		string :windows, :multiple => true
#		string :assessments, :multiple => true
#		string :forms_of_contact, :multiple => true
#		string :locations_of_use, :multiple => true
#	end

end
