class AddManyAttributesToUser < ActiveRecord::Migration
	def self.up
		add_column :users, :first_name, :string
		add_column :users, :last_name, :string
		add_column :users, :degrees, :string
		add_column :users, :title, :string
		add_column :users, :profession, :string
		add_column :users, :organization, :string
		add_column :users, :address, :text
		add_column :users, :phone_number, :string
		add_column :users, :research_interests, :text
		add_column :users, :selected_publications, :text
	end

	def self.down
		remove_column :users, :selected_publications
		remove_column :users, :research_interests
		remove_column :users, :phone_number
		remove_column :users, :address
		remove_column :users, :organization
		remove_column :users, :profession
		remove_column :users, :title
		remove_column :users, :degrees
		remove_column :users, :last_name
		remove_column :users, :first_name
	end
end
