# A sample Gemfile
source "http://rubygems.org"
source "http://gems.rubyforge.org"
source "http://gemcutter.org"

#	I don't believe that this source is active any longer.
source "http://gems.github.com"





gem 'rails', '~> 3.2'

gem 'sqlite3'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.0.3'
end

gem 'tinymce-rails', '~> 3'		#	the 4.* versions are for rails 4

gem "RedCloth"

gem "arel"

gem "chronic"

#gem "haml"
gem "hpricot"

#gem "rack", "=1.1.2"
gem 'rack-ssl', :require => 'rack/ssl'

gem "ryanb-acts-as-list", :require => 'acts_as_list'

gem "will_paginate"

gem 'mysql'
gem 'mysql2'

gem "paperclip"

gem "rdoc"
gem "aws-s3"
gem 'aws-sdk'

gem "authlogic"
gem "ruby-hmac"

gem 'minitest'

group :test do
	gem "ccls-html_test"

	# This does not work as well as rcov used to, imo.
	gem "simplecov", :require => false

	gem 'test-unit'

	gem "mocha", '0.13.3', :require => false

	gem "autotest-rails", :require => 'autotest/rails'


	#	try upgrading ZenTest (4.9.0 still has "illformed" gemspec (problem with old rubygems))
	gem 'ZenTest', '=4.9.1'
	#	ZenTest 4.9.2 always ends tests with ...
	#Run options: --seed 6126
	#
	## Running:
	#
	#
	#
	#Finished in 0.001282s, 0.0000 runs/s, 0.0000 assertions/s.
	#
	#0 runs, 0 assertions, 0 failures, 0 errors, 0 skips
	#
	#	and uses minitest/autorun rather that test/unit
	#
	#	/opt/local/bin/ruby1.9 -I.:lib:test -rubygems -e "%w[minitest/autorun 
	#		test/integration/addressing_integration_test.rb].each { |f| require f }"
	#	
	#	/opt/local/bin/ruby1.9 -I.:lib:test -rubygems -e "%w[test/unit 
	#		test/integration/addressing_integration_test.rb].each { |f| require f }"
	#
	#	... and also does not summarize errors and failures at the end??
	#



	gem "factory_girl_rails"
end

gem "ccls-common_lib", ">0.9"

