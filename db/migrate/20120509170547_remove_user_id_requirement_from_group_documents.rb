class RemoveUserIdRequirementFromGroupDocuments < ActiveRecord::Migration
	def self.up
#
#	Have this restriction ONLY in application.
#	Acts as list causes so issues that trigger database errors in testing.
#
		change_column :group_documents, :user_id, :integer, :null => true
	end

	def self.down
		change_column :group_documents, :user_id, :integer, :null => false
	end
end
