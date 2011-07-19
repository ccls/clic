class ChangePublicationsPublicationYearToInteger < ActiveRecord::Migration
	def self.up
		change_column :publications, :publication_year, :integer
	end

	def self.down
		change_column :publications, :publication_year, :string
	end
end
