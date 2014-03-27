class UserProfession < ActiveRecord::Base
	belongs_to :user
	belongs_to :profession
	attr_protected :user_id, :profession_id
end
