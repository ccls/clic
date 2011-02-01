#	Topic class
class Topic < ActiveRecord::Base
	belongs_to :forum
	belongs_to :user
	has_many :posts
	validates_presence_of :title
	validates_uniqueness_of :title
end
