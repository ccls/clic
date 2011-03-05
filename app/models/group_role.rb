class GroupRole < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position
#	has_and_belongs_to_many :users, :uniq => true
	has_many :memberships
	has_many :users,  :through => :memberships
	has_many :groups, :through => :memberships
	validates_presence_of   :name
	validates_uniqueness_of :name
end
