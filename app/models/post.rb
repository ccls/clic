#	Post class
class Post < ActiveRecord::Base
	belongs_to :topic
	belongs_to :user
	validates_presence_of :body

	def to_s
		body[0..9]
	end

end
