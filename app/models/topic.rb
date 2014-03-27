#	Topic class
class Topic < ActiveRecord::Base

	belongs_to :forum, :counter_cache => true
	belongs_to :user,  :counter_cache => true
	has_many :posts, :dependent => :destroy

	validations_from_yaml_file

	accepts_nested_attributes_for :posts

#	has_one :last_post, :class_name => 'Post', 
#		:order => "created_at DESC"
	def last_post
		posts.order('created_at DESC').first
	end

	attr_protected :user_id, :forum_id

#	before_validation_on_create :set_post_attributes
	before_validation :set_post_attributes, :on => :create

	def to_s
		title
	end

protected

	def set_post_attributes
		posts.each do |p|
			p.user  = user
		end
	end

end
