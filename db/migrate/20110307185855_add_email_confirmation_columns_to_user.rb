class AddEmailConfirmationColumnsToUser < ActiveRecord::Migration
	def self.up
		change_table :users do |t|
			t.string   :old_email
			t.datetime :email_confirmed_at
		end
	end

	def self.down
		change_table :users do |t|
			t.remove :old_email
			t.remove :email_confirmed_at
		end
	end
end
