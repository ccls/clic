class AddBeginAndEndTimeFieldsToEvent < ActiveRecord::Migration
	def self.up
		add_column :events, :begins_at_hour, :integer
		add_column :events, :begins_at_minute, :integer
		add_column :events, :begins_at_meridiem, :string
		add_column :events, :ends_at_hour, :integer
		add_column :events, :ends_at_minute, :integer
		add_column :events, :ends_at_meridiem, :string
	end

	def self.down
		remove_column :events, :begins_at_hour
		remove_column :events, :begins_at_minute
		remove_column :events, :begins_at_meridiem
		remove_column :events, :ends_at_hour
		remove_column :events, :ends_at_minute
		remove_column :events, :ends_at_meridiem
	end
end
