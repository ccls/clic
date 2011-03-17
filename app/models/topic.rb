#	Topic class
class Topic < ActiveRecord::Base
	belongs_to :forum, :counter_cache => true
	belongs_to :user,  :counter_cache => true
	has_many :posts, :dependent => :destroy
	validates_presence_of :title
#	validates_uniqueness_of :title

	accepts_nested_attributes_for :posts	#	really just for create

	def to_s
		title
	end

end
