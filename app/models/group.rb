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

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching name.
	def self.[](name)
#		find_by_name(name.to_s) #|| raise(NotFound)
		where(name:name.to_s).first #|| raise(NotFound)
	end

protected

	def cannot_be_own_child
		errors.add( :parent_id, "cannot be own child." 
			) if( ( !id.nil? ) && ( id == parent_id ) )

#	do it this way to give it its own error "type" (:unconfirmed_email here)
#			errors.add(:base, ActiveRecord::Error.new(
#				self, :base, :unconfirmed_email,
#				{ :message => "You have not yet confirmed your email address." })
#				) unless attempted_record.email_confirmed?
	end

end
