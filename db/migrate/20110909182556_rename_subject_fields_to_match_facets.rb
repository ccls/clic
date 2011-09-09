class RenameSubjectFieldsToMatchFacets < ActiveRecord::Migration
	def self.up
		rename_column :subjects, :case_control,     :case_status
		rename_column :subjects, :leukemiatype,     :leukemia_type
		rename_column :subjects, :income_quint,     :household_income
		rename_column :subjects, :downs,            :down_syndrome
		rename_column :subjects, :father_age_birth, :father_age
		rename_column :subjects, :mother_age_birth, :mother_age
	end

	def self.down
		rename_column :subjects, :case_status,      :case_control
		rename_column :subjects, :leukemia_type,    :leukemiatype
		rename_column :subjects, :household_income, :income_quint
		rename_column :subjects, :down_syndrome,    :downs
		rename_column :subjects, :father_age,       :father_age_birth
		rename_column :subjects, :mother_age,       :mother_age_birth
	end
end
