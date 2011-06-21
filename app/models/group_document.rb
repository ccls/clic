require 'hmac-sha1'
#
#	http://amazon.rubyforge.org/
#
class GroupDocument < ActiveRecord::Base
	belongs_to :group	#	sometimes
	belongs_to :user
	belongs_to :attachable, :polymorphic => true

#	TODO protect user_id and add attr_accessor current_user 

	attr_protected :user_id, :group_id

	validates_presence_of :user, :title
	validates_length_of :title,       :maximum => 250
	validates_length_of :description, :maximum => 65000, :allow_blank => true

#	WHY? (blank creates an error, nil does not)
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
