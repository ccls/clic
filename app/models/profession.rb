class Profession < ActiveRecord::Base

	default_scope :order => :position
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