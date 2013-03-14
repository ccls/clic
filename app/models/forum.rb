#	Forum class
class Forum < ActiveRecord::Base

	belongs_to :group
	has_many :topics, :dependent => :destroy
	validates_presence_of   :name
	validates_uniqueness_of :name, :scope => :group_id
	#	using allow_blank => true removes the "too long" error when it is blank
	validates_length_of     :name, :maximum => 250, :allow_blank => true

#	scope :groupless, :conditions => { :group_id => nil }
	scope :groupless, where( :group_id => nil )

#	has_one :last_post, :class_name => 'Post',
#		:through => :topics, :order => 'created_at DESC'
	has_many :posts, :through => :topics
	def last_post
		posts.order('created_at DESC').first
	end

	attr_protected :group_id

	def to_s
		name
	end

end
