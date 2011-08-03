class AddAttributesToStudies < ActiveRecord::Migration
	def self.up
		change_table(:studies) do |t|
			t.string :world_region
			t.string :country
			t.string :design
			t.string :recruitment
			t.string :target_age_group
			t.text :principal_investigators
			t.text :overview
		end
	end

	def self.down
		change_table(:studies) do |t|
			t.remove :world_region
			t.remove :country
			t.remove :design
			t.remove :recruitment
			t.remove :target_age_group
			t.remove :principal_investigators
			t.remove :overview
		end
	end
end
