class UserProfession < ActiveRecord::Base
	belongs_to :user
	belongs_to :profession
#	don't do this.  In rails 3 just raises error
#	validates_presence_of :user, :profession
	attr_protected :user_id, :profession_id
end
