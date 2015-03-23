#	Forum class
class Forum < ActiveRecord::Base

	belongs_to :group
	has_many :topics, :dependent => :destroy

	validations_from_yaml_file

	scope :groupless, ->{ where( :group_id => nil ) }

	has_many :posts, :through => :topics
	def last_post
		posts.order('created_at DESC').first
	end

	def to_s
		name
	end

end
