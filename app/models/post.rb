#	Post class
class Post < ActiveRecord::Base
	default_scope :order => 'created_at DESC'
	belongs_to :topic, :counter_cache => true
	belongs_to :user,  :counter_cache => true
	has_many   :group_documents, :dependent => :destroy, :as => :attachable

	validates_presence_of :topic, :user, :body
	validates_length_of   :body, :maximum => 65000

#	TODO accepts_nested_attributes_for :group_documents

	after_create   :increment_forum_posts_count
	before_destroy :decrement_forum_posts_count

	def to_s
		body[0..9]
	end

protected

	def increment_forum_posts_count
		Forum.increment_counter(:posts_count, topic.forum_id)
	end

	def decrement_forum_posts_count
		Forum.decrement_counter(:posts_count, topic.forum_id)
	end

end
