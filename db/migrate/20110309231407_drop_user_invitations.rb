class DropUserInvitations < ActiveRecord::Migration
	def self.down
		create_table :user_invitations do |t|
			t.integer  :sender_id
			t.string   :email
			t.string   :token
			t.datetime :accepted_at
			t.integer  :recipient_id
			t.text     :message
			t.datetime :sent_at
			t.timestamps
		end unless table_exists?(:user_invitations)
	end

	def self.up
		drop_table :user_invitations
	end
end
