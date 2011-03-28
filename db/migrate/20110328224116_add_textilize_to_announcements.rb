class AddTextilizeToAnnouncements < ActiveRecord::Migration
	def self.up
		add_column :announcements, :textilize, :boolean, :default => false
	end

	def self.down
		remove_column :announcements, :textilize
	end
end
