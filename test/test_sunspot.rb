#	http://timcowlishaw.co.uk/post/3179661158/testing-sunspot-with-test-unit
module TestSunspot
#
#	I don't actually use this.
#
#	class << self
#		attr_accessor :pid, :original_session, :stub_session, :server
#		 
#		def setup
##	NOT the test_case setup.	Should probably be renamed to something like "prepare"
##puts "TestSunspot setup"
#			TestSunspot.original_session = Sunspot.session
#			Sunspot.session = TestSunspot.stub_session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)
#		end
# 
#	end
#	def self.included(klass)
##puts "TestSunspot included #{klass}"
#		klass.instance_eval do
##	startup and shutdown callbacks require test-unit 2.x
##	which seems to be incompatible with either ruby 1.8 or rails 2.3.12
##	added some hacking to sort of fake startup before first test
##		and teardown after last test.
#			def startup
##puts "TestSunspot startup"
#				Sunspot.session = TestSunspot.original_session
#				rd, wr = IO.pipe
#				pid = fork do
#					STDOUT.reopen(wr)
#					STDERR.reopen(wr)
#					TestSunspot.server ||= Sunspot::Rails::Server.new
#					begin
#						TestSunspot.server.run
#					ensure
#						wr.close
#					end
#				end
#				TestSunspot.pid = pid
#				ready = false
#				until ready do
#					ready = true if rd.gets =~ /Started\ SocketConnector/
#					sleep 0.5
#				end
#				rd.close
#			end
# 
#			def shutdown
#puts "TestSunspot shutdown"
#				Sunspot.remove_all!
#puts "Killing:#{TestSunspot.pid}:"
#				Process.kill("HUP",TestSunspot.pid)
#puts "Killed:#{TestSunspot.pid}:waiting"
##puts		Process.kill(0,TestSunspot.pid)
#				Process.wait
#puts "Done waiting"
#			rescue Errno::ESRCH	#: No such process
#puts "In rescue Errno::ESRCH"
#			ensure
#puts "In ensure"
#				Sunspot.session = TestSunspot.stub_session
#			end
#		end
#		def teardown
##puts "TestSunspot teardown"
#			Sunspot.remove_all!
#		end
#	end
end
