module TestStartupShutdown
#
#	I don't actually use this.
#
#
##	Newer versions of test-unit include startup and shutdown callbacks
##	which run before the first test and after the last test in the suite.
##	This hack attempts to mimic this as the newer versions of test-unit
##	do not seem to be compatible with rails 2.3.12 or ruby 1.8.
##	Basically, run_startup is called from the setup of each test, but only
##	calls startup for the first test.  run_shutdown is called from
##	the teardown of each test, but only calls shutdown for the last test.
##	This is only used for testing sunspot.
#
#	def self.included(base)
#		base.class_eval do
#			@@ran_tests = 0
#			@@ran_startup = false
#			base.setup    :run_startup
#			base.teardown :run_shutdown
#		end
#	end
#
#	def run_startup
#		unless @@ran_startup
##			puts "Running run_startup"
#			@@ran_startup = true
#			self.class.startup if self.class.respond_to?(:startup)
##		else
##			puts "Skipping run_startup"
#		end
#		@@ran_tests += 1
#	end
#
#	def run_shutdown
#		if @@ran_tests >= self.class.suite.tests.length
##			puts "Last test in suite: Running shutdown"
#			self.class.shutdown if self.class.respond_to?(:shutdown)
##		else
##			puts "NOT last test in suite: Skipping"
#		end
#	end
#
end
