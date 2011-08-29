class RenameTableEventsToAnnouncements < ActiveRecord::Migration
	def self.up
		rename_table :events, :announcements
	end

	def self.down
		rename_table :announcements, :events
	end
end
