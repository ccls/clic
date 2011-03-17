#	Forum class
class Forum < ActiveRecord::Base

	belongs_to :group
	has_many :topics, :dependent => :destroy
	validates_presence_of :name
	validates_uniqueness_of :name, :scope => :group_id

	named_scope :groupless, :conditions => {
		:group_id => nil }

	def to_s
		name
	end

end
