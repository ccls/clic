class UserSession < Authlogic::Session::Base

	consecutive_failed_logins_limit 50

	#authlogic / lib / authlogic / session / magic_states.rb 
	# won't allow login of user that is not approved? confirmed? or active?
	# if those fields exist
	# Our "approved" column is used for something different
	disable_magic_states true

	validate :has_email_address_been_confirmed

private

	def has_email_address_been_confirmed
		if attempted_record
			errors.add(:unconfirmed_email, "You have not yet confirmed your email address."
				) unless attempted_record.email_confirmed?
		end
	end

end
