ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

#$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
#require 'factory_test_helper'

#	Using default validation settings from within the 
#	html_test and html_test_extension plugins

class ActiveSupport::TestCase
	fixtures :all
end

class ActionController::TestCase
	setup :turn_https_on
end
