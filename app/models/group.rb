#	Group class
class Group < ActiveRecord::Base

	attr_accessible :name, :description, :parent_id

	acts_as_list :scope => :parent_id

	with_options :class_name => 'Group' do |o|
		o.belongs_to :parent, :counter_cache => :groups_count
		o.has_many :children, 
			:foreign_key => 'parent_id',
			:dependent => :nullify
	end
	has_many :announcements
	has_many :documents, :class_name => 'GroupDocument'
	has_many :memberships
	has_many :users, :through => :memberships
	has_many :forums
	
	scope :joinable,  ->{ where( :groups_count => 0 ) }
	scope :roots,     ->{ where( :parent_id => nil ) }
	scope :not_roots, ->{ where( Group.arel_table[:parent_id].not_eq(nil) ) }

	validations_from_yaml_file

	validate :cannot_be_own_child

	def to_s
		name
	end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching name.
	def self.[](name)
		where(name:name.to_s).first
	end

protected

	def cannot_be_own_child
		errors.add( :parent_id, "cannot be own child." 
			) if( ( !id.nil? ) && ( id == parent_id ) )
	end

end
