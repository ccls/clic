#	Post class
class Post < ActiveRecord::Base
	default_scope :order => 'created_at DESC'
	belongs_to :topic, :counter_cache => true
	belongs_to :user,  :counter_cache => true
	has_many   :group_documents, :dependent => :destroy

	validates_presence_of :topic
	validates_presence_of :user
	validates_presence_of :body

	after_create :increment_forum_posts_count
	def increment_forum_posts_count
		Forum.increment_counter(:posts_count, topic.forum_id)
	end

	before_destroy :decrement_forum_posts_count
	def decrement_forum_posts_count
		Forum.decrement_counter(:posts_count, topic.forum_id)
	end

	def to_s
		body[0..9]
	end

end
