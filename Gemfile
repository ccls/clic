source "http://rubygems.org"

gem 'rails', '~> 4.0'	#	without a version, it installed rails 0.9.6!
gem 'protected_attributes'	#	to keep rails 3 style

gem 'sqlite3'

#group :assets do
#  gem 'sass-rails'
#  gem 'coffee-rails'
#  gem 'uglifier', '>= 1.0.3'
#end

gem 'tinymce-rails'

gem "RedCloth"

gem "arel"

gem "chronic"

gem "hpricot"

gem 'rack-ssl', :require => 'rack/ssl'

gem "acts_as_list"

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
	#	simplecov-0.8.1 or one of its dependencies causes autotest to not actually run tests?
	gem "simplecov", '0.7.1', :require => false

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
	gem "jakewendt-test_with_verbosity"
end

gem "ccls-common_lib", ">0.9"

