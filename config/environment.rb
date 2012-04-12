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
		config.gem "sqlite3"
	end

	config.gem 'ryanb-acts-as-list', :lib => 'acts_as_list'
	config.gem 'authlogic', :version => '~> 2'
	config.gem 'jrails'	#	for jquery helpers

	#	2.4.3 causes a lot of ...
	#	NameError: `@[]' is not allowed as an instance variable name
	config.gem 'paperclip', '=2.4.2'

	config.gem 'ruby-hmac', :lib => 'ruby_hmac'
	config.gem "aws-s3", :lib => "aws/s3"

#	config.gem 'ccls-simply_authorized'
#	config.gem 'ccls-common_lib'

	#		http://chronic.rubyforge.org/
	#	I'd really like to remove chronic, but it is actually used here.
	config.gem "chronic"	#, :version => '= 0.5.0'
	config.gem 'will_paginate'
	config.gem 'fastercsv'
	config.gem 'hpricot'
	config.gem 'RedCloth', '< 4.2.6'
	config.gem "sunspot_rails"

	config.frameworks -= [ :active_resource ]

	# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names.
	config.time_zone = 'UTC'

end

#	Don't know why I need this ...
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
# simple helper
HWIA = HashWithIndifferentAccess



HTML::WhiteListSanitizer.allowed_attributes.merge(%w( id class style ))


__END__
# A sample Gemfile
source "http://rubygems.org"
source "http://gems.rubyforge.org"
source "http://gemcutter.org"

#	I don't believe that this source is active any longer.
source "http://gems.github.com"


#	rubygems > 1.6.2 is EVIL!  If you update, you deal with it.
#		generates all kinds of new errors and deprecation warnings
#		somehow loads older versions of gems, then bitches when you try to load the newest.
#		(may be fixable with "gem pristine --all --no-extensions", but haven't tried)
#	rake 0.9.0 caused some errors.  can't remember
#	arel > 2.0.2 caused some errors.
#	some gem versions require rails 3, so have to use older versions
#		authlogic, will_paginate

#	gem install rubygems-update -v '1.6.2'
#	update_rubygems


#
#	NO SPACES BETWEEN OPERATOR AND VERSION NUMBER!
#
gem "rake", '=0.8.7'
gem "rails", "~>2"

#	Why?  Can't remember.
gem "RedCloth", '<4.2.8'

gem "arel", "=2.0.2"

#	Trying to remove Chronic usage
#	still in calnet_authenticated
#	0.6.7 doesn't install in jruby?
gem "chronic",	'<=0.6.6'

gem "haml"
gem "hpricot"
gem "i18n"
gem "jrails"

gem "rack", "=1.1.2"

gem "ryanb-acts-as-list"
gem "ssl_requirement"
gem "will_paginate", "~>2"

gem "ccls-calnet_authenticated"
gem "ccls-common_lib"
gem "ccls-simply_authorized"

gem "warbler"
#	jruby-jars-1.6.6 causes issues
gem "jruby-jars", "=1.6.5"
gem "jruby-openssl"
gem "jruby-rack", "=1.0.10"
gem "jdbc-mysql"
gem "jdbc-sqlite3"
gem "activerecord-jdbcsqlite3-adapter"
gem "activerecord-jdbcmysql-adapter"

#Java::JavaLang::ArrayIndexOutOfBoundsException: An error occured while installing rubyzip (0.9.5), and Bundler cannot continue.
#	why
#gem 'rubyzip', '=0.9.4'	#	0.9.5 fails
#	not true anymore (warbler uses this)

#	Used for cvs parsing on data import
#	Also used to csv output.
#gem "fastercsv"

#	2.4.3, 2.4.5 causes a lot of ...
#	NameError: `@[]' is not allowed as an instance variable name
#    paperclip (2.4.5) lib/paperclip/options.rb:60:in `instance_variable_get'
#    paperclip (2.4.5) lib/paperclip/options.rb:60:in `method_missing'
gem "paperclip", '=2.4.2'	#	only used by buffler and clic

#	rarely used
gem "rdoc", "~>2"
gem "aws-s3"


gem "authlogic", "~> 2"
gem "ruby-hmac"
gem "rsolr", "=0.12.1"
gem "sunspot", "=1.2.1"
gem "sunspot_rails", "=1.2.1"


#
#	Everything seems to work with this ...
#
#	actionmailer (2.3.14)
#	actionpack (2.3.14)
#	activerecord (2.3.14)
#	activerecord-jdbc-adapter (1.2.2)
#	activerecord-jdbcmysql-adapter (1.2.2)
#	activerecord-jdbcsqlite3-adapter (1.2.2)
#	activeresource (2.3.14)
#	activesupport (2.3.14)
#	arel (2.0.2)
#	authlogic (2.1.6)
#	aws-s3 (0.6.2)
#	bouncy-castle-java (1.5.0146.1)
#	builder (3.0.0)
#	bundler (1.0.22)
#	ccls-calnet_authenticated (1.3.2)
#	ccls-common_lib (0.1.7)
#	ccls-simply_authorized (1.4.0)
#	chronic (0.6.6)
#	cocaine (0.2.1)
#	columnize (0.3.1)
#	escape (0.0.4)
#	fastercsv (1.5.4)
#	git (1.2.5)
#	haml (3.1.4)
#	hpricot (0.8.6 java)
#	i18n (0.6.0)
#	jdbc-mysql (5.1.13)
#	jdbc-sqlite3 (3.7.2)
#	jrails (0.6.0)
#	jruby-jars (1.6.5)
#	jruby-launcher (1.0.12 java)
#	jruby-openssl (0.7.5, 0.7.4)
#	jruby-rack (1.0.10)
#	json (1.6.5 java)
#	mime-types (1.17.2)
#	nokogiri (1.5.0 java)
#	paperclip (2.4.2)
#	pr_geohash (1.0.0)
#	rack (1.1.2)
#	rails (2.3.14)
#	rake (0.8.7)
#	rdoc (2.5.11)
#	RedCloth (4.2.7 java)
#	rsolr (0.12.1)
#	rspec (1.3.0)
#	ruby-debug (0.10.3)
#	ruby-debug-base (0.10.3.2 java)
#	ruby-hmac (0.4.0)
#	ruby-net-ldap (0.0.4)
#	rubycas-client (2.3.8)
#	rubygems-update (1.6.2)
#	rubyzip (0.9.6.1)
#	ryanb-acts-as-list (0.1.2)
#	sources (0.0.1)
#	ssl_requirement (0.1.0)
#	sunspot (1.2.1)
#	sunspot_rails (1.2.1)
#	ucb_ldap (1.4.2)
#	warbler (1.3.2)
#	will_paginate (2.3.16)
#	xml-simple (1.1.1)
