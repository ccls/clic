#	Post class
class Post < ActiveRecord::Base
	belongs_to :topic, :counter_cache => true
	belongs_to :user,  :counter_cache => true
	validates_presence_of :body

	after_create :increment_forum_posts_count
	def increment_forum_posts_count
		Forum.increment_counter(:posts_count, topic.forum.id)
	end

	before_destroy :decrement_forum_posts_count
	def decrement_forum_posts_count
		Forum.decrement_counter(:posts_count, topic.forum.id)
	end

#	may have attached document

	def to_s
		body[0..9]
	end

end
