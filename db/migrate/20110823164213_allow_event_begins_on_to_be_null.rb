class AllowEventBeginsOnToBeNull < ActiveRecord::Migration
	def self.up
		change_column :events, :begins_on, :date, :null => true
	end

	def self.down
		change_column :events, :begins_on, :date, :null => false
	end
end
