class Event < ActiveRecord::Base
	default_scope :order => 'begins_on DESC'
	belongs_to :user
	belongs_to :group

	validates_presence_of :user
	validates_presence_of :title
	validates_presence_of :content
	validates_presence_of :begins_on
	validates_complete_date_for :begins_on

	validates_inclusion_of :begins_at_hour, :in => 1..12,
		:allow_blank => true
	validates_inclusion_of :begins_at_minute, :in => 0..59,
		:allow_blank => true
	validates_format_of :begins_at_meridiem, :with => /\A(AM|PM)\z/i,
		:allow_blank => true
	validates_inclusion_of :ends_at_hour, :in => 1..12,
		:allow_blank => true
	validates_inclusion_of :ends_at_minute, :in => 0..59,
		:allow_blank => true
	validates_format_of :ends_at_meridiem, :with => /\A(AM|PM)\z/i,
		:allow_blank => true

	attr_protected :group_id
	attr_protected :user_id

	named_scope :groupless, :conditions => {
		:group_id => nil }

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
