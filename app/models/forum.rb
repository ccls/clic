class Forum < ActiveRecord::Base
	belongs_to :group
	has_many :topics
	validates_presence_of :name
	validates_uniqueness_of :name
end
