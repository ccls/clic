class Questionnaire < ActiveRecord::Base

	belongs_to :study

	validates_presence_of :study_id
	validates_presence_of :title
	validates_length_of   :title, :in => 4..250

	before_validation :nullify_blank_document_file_name

	has_attached_file :document,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/questionnaire.yml')
		))).result)[Rails.env]

	def nullify_blank_document_file_name
		self.document_file_name = nil if document_file_name.blank?
	end

	def to_s
		title
	end

end
