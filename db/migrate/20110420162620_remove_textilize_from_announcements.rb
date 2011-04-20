class RemoveTextilizeFromAnnouncements < ActiveRecord::Migration
	def self.up
		remove_column :announcements, :textilize
	end

	def self.down
		add_column :announcements, :textilize, :boolean, :default => false
	end
end
