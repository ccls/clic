#	Forum class
class Forum < ActiveRecord::Base

	belongs_to :group
	has_many :topics, :dependent => :destroy
	validates_presence_of   :name
	validates_uniqueness_of :name, :scope => :group_id
	validates_length_of     :name, :maximum => 250

	named_scope :groupless, :conditions => {
		:group_id => nil }

	has_one :last_post, :class_name => 'Post',
		:through => :topics, :order => 'created_at DESC'

	attr_protected :group_id

	def to_s
		name
	end

end
