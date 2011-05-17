class CreateAnnualMeetings < ActiveRecord::Migration
	def self.up
		create_table :annual_meetings do |t|
			t.string :meeting
			t.text :abstract
			t.timestamps
		end
		add_index :annual_meetings, :meeting
	end

	def self.down
		drop_table :annual_meetings
	end
end
