#	Topic class
class Topic < ActiveRecord::Base

#	default scopes are EVIL.  They seem to take precedence
#	over you actual query which seems really stupid
#	removing all in rails 3 which will probably require
#	modifications to compensate in the methods that expected them
#	default_scope :order => 'created_at DESC'

	belongs_to :forum, :counter_cache => true
	belongs_to :user,  :counter_cache => true
	has_many :posts, :dependent => :destroy
	validates_presence_of :title
#	validates_uniqueness_of :title
	validates_length_of :title, :maximum => 250

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
