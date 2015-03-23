class Announcement < ActiveRecord::Base

	belongs_to :user
	belongs_to :group

	validations_from_yaml_file

	scope :groupless, ->{ where( :group_id => nil ) }

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
		begins = ( begins_on.nil? ) ? '' : "#{begins_on.month}/#{begins_on.day}/#{begins_on.year}"
		unless( ( at = begins_at ).blank? )
			begins << " ( #{at} )"
		end
		begins
	end

	def ends
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
