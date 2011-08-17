# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

#	I really shouldn't need this.
#ENV['RAILS_ENV'] ||= 'production'

#	In production, using script/console does not properly
#	set a GEM_PATH, so gems aren't loaded correctly.
if ENV['RAILS_ENV'] == 'production'
ENV['GEM_PATH'] = File.expand_path(File.join(File.dirname(__FILE__),'..','gems'))
end

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#	This constant is used in the ucb_ccls_engine#Document
#	and other places like Amazon buckets
#	for controlling the path to documents.
RAILS_APP_NAME = 'clic'

Rails::Initializer.run do |config|

	if RUBY_PLATFORM =~ /java/
		config.gem 'activerecord-jdbcsqlite3-adapter',
			:lib => 'active_record/connection_adapters/jdbcsqlite3_adapter'
		config.gem 'activerecord-jdbcmysql-adapter',
			:lib => 'active_record/connection_adapters/jdbcmysql_adapter'
		config.gem 'jdbc-mysql', :lib => 'jdbc/mysql'
		config.gem 'jdbc-sqlite3', :lib => 'jdbc/sqlite3'
		config.gem 'jruby-openssl', :lib => 'openssl'
	else
		config.gem 'mysql'
#		config.gem "sqlite3-ruby", :lib => "sqlite3"
		config.gem "sqlite3"
	end

	config.gem 'ryanb-acts-as-list', :lib => 'acts_as_list'
	config.gem 'authlogic', :version => '~> 2'
	config.gem 'paperclip'
	config.gem 'gravatar'	#	needed until removed from simply_pages
	config.gem 'ruby-hmac', :lib => 'ruby_hmac'
	config.gem "aws-s3", :lib => "aws/s3"
	config.gem 'jakewendt-simply_helpful'
	config.gem 'jakewendt-simply_authorized'
	config.gem 'jakewendt-simply_pages'
	config.gem 'jakewendt-simply_photos'
	config.gem 'jakewendt-ruby_extension'
	config.gem 'jakewendt-rails_extension'

	#	require it, but don't load it
	config.gem 'jakewendt-rdoc_rails', :lib => false

	#		http://chronic.rubyforge.org/
	config.gem "chronic"	#, :version => '= 0.5.0'
	config.gem 'will_paginate'
	config.gem 'fastercsv'
	config.gem 'hpricot'

	config.gem "sunspot_rails"

	config.frameworks -= [ :active_resource ]

	# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names.
	config.time_zone = 'UTC'

end

if RUBY_PLATFORM =~ /java/i
	require 'file_utils_extension'
end
require 'acts_as_list'

#	don't use the default div wrappers as they muck up style
#	just adding a class to the tag is a little better
require 'hpricot'
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| 
	error_class = 'field_error'
	nodes = Hpricot(html_tag)
	nodes.each_child { |node| 
		node[:class] = node.classes.push(error_class).join(' ') unless !node.elem? || node[:type] == 'hidden' || node.classes.include?(error_class) 
	}
	nodes.to_html
}

