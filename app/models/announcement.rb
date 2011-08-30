class Announcement < ActiveRecord::Base
	default_scope :order => 'created_at DESC, begins_on DESC'
	belongs_to :user
	belongs_to :group

	validates_presence_of :user, :title, :content
	validates_length_of :title,   :maximum => 250
	validates_length_of :content, :maximum => 65000
	validates_presence_of :begins_on, :if => :ends_on
	validates_complete_date_for :begins_on, :ends_on, :allow_nil => true

	validates_inclusion_of :begins_at_hour,     :ends_at_hour, 
		:in => (1..12), :allow_blank => true
	validates_inclusion_of :begins_at_minute,   :ends_at_minute,
		:in => (0..59), :allow_blank => true
	validates_format_of    :begins_at_meridiem, :ends_at_meridiem,
		:with => /\A(AM|PM)\z/i, :allow_blank => true

	attr_protected :group_id, :user_id

	named_scope :groupless, :conditions => {
		:group_id => nil }

	validate :begins_at_is_before_ends_at

	def begins_at_is_before_ends_at
		errors.add(:ends_on, "must be after begins_on"
			) if ends_at_is_before_begins_at?
	end

	def ends_at_is_before_begins_at?
		if begins_on and ends_on
			Chronic.parse("#{begins_on.to_date} #{begins_at}"
				) > Chronic.parse("#{ends_on.to_date} #{ends_at}")
		else
			false
		end
	end

	def to_s
		title
	end

	def begins
#		begins = ( begins_on.nil? ) ? '' : begins_on.strftime("%m/%d/%Y").gsub(/^0/,'')
#	NO leading zeros
		begins = ( begins_on.nil? ) ? '' : "#{begins_on.month}/#{begins_on.day}/#{begins_on.year}"
		unless( ( at = begins_at ).blank? )
			begins << " ( #{at} )"
		end
		begins
	end

	def ends
#		ends = ( ends_on.nil? ) ? '' : ends_on.strftime("%m/%d/%Y").gsub(/^0/,'')
#	NO leading zeros
		ends = ( ends_on.nil? ) ? '' : "#{ends_on.month}/#{ends_on.day}/#{ends_on.year}"
		unless( ( at = ends_at ).blank? )
			ends << " ( #{at} )"
		end
		ends
	end

	def time
		time = begins
		unless ends.blank?
			time << " - #{ends}"
		end
		time
	end

	def begins_at
		if begins_at_hour && begins_at_minute && begins_at_meridiem.upcase
			"#{begins_at_hour}:#{sprintf("%02d",begins_at_minute)} #{begins_at_meridiem.upcase}"
		else
			''
		end
	end

	def ends_at
		if ends_at_hour && ends_at_minute && ends_at_meridiem.upcase
			"#{ends_at_hour}:#{sprintf("%02d",ends_at_minute)} #{ends_at_meridiem.upcase}"
		else
			''
		end
	end

end
