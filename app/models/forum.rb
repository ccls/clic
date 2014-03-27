#	Forum class
class Forum < ActiveRecord::Base

	belongs_to :group
	has_many :topics, :dependent => :destroy

	validations_from_yaml_file

	scope :groupless, ->{ where( :group_id => nil ) }

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
