require 'hmac-sha1'
#
#	http://amazon.rubyforge.org/
#
class GroupDocument < ActiveRecord::Base
	belongs_to :group
	belongs_to :user

	validates_presence_of :group
	validates_presence_of :user
	validates_presence_of :title
#	validates_presence_of :content


#	WHY?
	before_validation :nullify_blank_document_file_name

	has_attached_file :document,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/group_document.yml')
		))).result)[Rails.env]

	def nullify_blank_document_file_name
		self.document_file_name = nil if document_file_name.blank?
	end

	def to_s
		title
	end

end
