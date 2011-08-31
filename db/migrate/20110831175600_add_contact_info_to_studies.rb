class AddContactInfoToStudies < ActiveRecord::Migration
	def self.up
		add_column :studies, :contact_info, :text
	end

	def self.down
		remove_column :studies, :contact_info
	end
end
