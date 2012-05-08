class AddPositionToAnnualMeetings < ActiveRecord::Migration
	def self.up
		add_column :annual_meetings, :position, :integer
	end

	def self.down
		remove_column :annual_meetings, :position
	end
end
