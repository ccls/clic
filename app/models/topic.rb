#	Topic class
class Topic < ActiveRecord::Base
	default_scope :order => 'created_at DESC'
	belongs_to :forum, :counter_cache => true
	belongs_to :user,  :counter_cache => true
	has_many :posts, :dependent => :destroy
	validates_presence_of :title
#	validates_uniqueness_of :title
	validates_length_of :title, :maximum => 250

	accepts_nested_attributes_for :posts

	has_one :last_post, :class_name => 'Post', 
		:order => "created_at DESC"

	before_validation_on_create :set_post_attributes

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
