#	Post class
class Post < ActiveRecord::Base

#	default scopes are EVIL.  They seem to take precedence
#	over you actual query which seems really stupid
#	removing all in rails 3 which will probably require
#	modifications to compensate in the methods that expected them
#	default_scope :order => 'created_at DESC'

	belongs_to :topic, :counter_cache => true
	belongs_to :user,  :counter_cache => true
	has_many   :group_documents, :dependent => :destroy, :as => :attachable

#	can't validate presence of topic when using nested_attributes
#	validates_presence_of :topic, :user, :body
#	validates_presence_of :user, :body
#	validates_length_of   :body, :maximum => 65000

	validations_from_yaml_file

	attr_protected :user_id, :topic_id

	accepts_nested_attributes_for :group_documents, 
		:reject_if => proc{|attributes| attributes['document'].blank? }

#	before_validation_on_create  :set_group_documents_user
	before_validation :set_group_documents_user, :on => :create
	before_create  :set_group_documents_group
	after_create   :increment_forum_posts_count
	before_destroy :decrement_forum_posts_count

	def to_s
		body[0..9]
	end

protected

	def set_group_documents_group
		group_documents.each do |gd|
			#	group isn't required at validation so can do it before create
			gd.group = topic.forum.group
		end
	end

	def set_group_documents_user
		group_documents.each do |gd|
#	topic will be nil on nested attribute creation, so need to wait
#			gd.group = topic.forum.group
			gd.user  = user
		end
	end

	def increment_forum_posts_count
		Forum.increment_counter(:posts_count, topic.forum_id)
	end

	def decrement_forum_posts_count
		Forum.decrement_counter(:posts_count, topic.forum_id)
	end

end
