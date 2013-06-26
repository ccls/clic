#	Group class
class Group < ActiveRecord::Base

	acts_as_list :scope => :parent_id

#	default scopes are EVIL.  They seem to take precedence
#	over you actual query which seems really stupid
#	removing all in rails 3 which will probably require
#	modifications to compensate in the methods that expected them
#	default_scope :order => 'parent_id,position'

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
	scope :not_roots, ->{ where( 'groups.parent_id IS NOT NULL' ) }

	validates_presence_of   :name
	validates_uniqueness_of :name
	validates_length_of     :name, :maximum => 250
	validate :cannot_be_own_child

	def to_s
		name
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching name.
	def self.[](name)
		find_by_name(name.to_s) #|| raise(NotFound)
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
