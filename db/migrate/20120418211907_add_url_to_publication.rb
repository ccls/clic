class AddUrlToPublication < ActiveRecord::Migration
	def self.up
		add_column :publications, :url, :string
	end

	def self.down
		remove_column :publications, :url
	end
end
