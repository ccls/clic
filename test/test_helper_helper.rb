#
#	I'm here to allow for the adding to test helper
#	without autotest restarting all of your tests.
#


class ActionController::TestCase

	#
	#	from minitest-5.3.3/lib/minitest/test.rb
	#
	def run
		with_info_handler do
			time_it do
				capture_exceptions do
					before_setup; setup; after_setup
					self.send self.name



					#
					#	I don't like it, but this works.  May want to watch the minitest gem to ensure
					#	that this method isn't updated.  If so, match and modify this.
					#
					#	If done in a teardown, failure will cause other teardowns not to be run. (no rollback)
					#
					#	if downloading pdf or something, this will fail. (send_file was used)
					#unless @response.headers['Content-Disposition'].try(:match,/attachment;.*pdf/)
#	Any reference to @response.body yields something like ...
#	Errno::ENOENT: No such file or directory - /Users/jakewendt/github_repo/ccls/clic/test/documents/594/edit_save_wireframe.pdf
#					unless @response.body.nil?
					unless @response.content_type == "application/pdf"
						assert_select 'form form', { :count => 0 }, "Found nested forms.  Nested are invalid html and very dangerous."
					end




				end

				%w{ before_teardown teardown after_teardown }.each do |hook|
					capture_exceptions do
						self.send hook
					end
				end
			end
		end

		self # per contract
	end

end


class ActiveSupport::TestCase

#
#	would this work for backward compatibility
#
#	Factory = FactoryGirl
	def Factory(*args)
		FactoryGirl.create(*args)
	end

end

__END__



#<ActionController::TestResponse:0x007ff5f48a1b18 @mon_owner=nil, @mon_count=0, @mon_mutex=#<Mutex:0x007ff5f3494350>, @stream=#<ActionController::DataStreaming::FileBody:0x007ff5f6c92ce8 @to_path="/Users/jakewendt/github_repo/ccls/clic/test/questionnaires/113/edit_save_wireframe.pdf">, @header={"X-Frame-Options"=>"SAMEORIGIN", "X-XSS-Protection"=>"1; mode=block", "X-Content-Type-Options"=>"nosniff", "Content-Disposition"=>"attachment; filename=\"edit_save_wireframe.pdf\"", "Content-Transfer-Encoding"=>"binary", "Content-Type"=>"application/pdf", "Cache-Control"=>"private"}, @status=200, @sending_file=true, @blank=false, @cv=#<MonitorMixin::ConditionVariable:0x007ff5f34941e8 @monitor=#<ActionController::TestResponse:0x007ff5f48a1b18 ...>, @cond=#<ConditionVariable:0x007ff5f34941c0 @waiters={}, @waiters_mutex=#<Mutex:0x007ff5f3494170>>>, @committed=false, @sending=false, @sent=false, @content_type="application/pdf", @charset="utf-8", @cache_control={:public=>false}, @etag=nil, @request=#<ActionController::TestRequest:0x007ff5f48a2c98 @env={"rack.version"=>[1, 2], "rack.input"=>#<StringIO:0x007ff5f349dae0>, "rack.errors"=>#<StringIO:0x007ff5f6aec358>, "rack.multithread"=>true, "rack.multiprocess"=>true, "rack.run_once"=>false, "REQUEST_METHOD"=>"GET", "SERVER_NAME"=>"example.org", "SERVER_PORT"=>"80", "QUERY_STRING"=>"", "rack.url_scheme"=>"http", "HTTPS"=>"off", "SCRIPT_NAME"=>nil, "CONTENT_LENGTH"=>"0", "HTTP_HOST"=>"test.host", "REMOTE_ADDR"=>"0.0.0.0", "HTTP_USER_AGENT"=>"Rails Testing", "action_dispatch.routes"=>#<ActionDispatch::Routing::RouteSet:0x007ff5f71e49f8>, "action_dispatch.parameter_filter"=>[:password, :password_confirmation, :current_password], "action_dispatch.redirect_filter"=>[], "action_dispatch.secret_token"=>nil, "action_dispatch.secret_key_base"=>"49f429b460fd8fd912e0f6b81c53c9fa4d1d96b59106249d0a488162bcee1ec76b5b813bd9c5a060222b80d7f0330532e2544d66cc93492160091ea9200d2ff5", "action_dispatch.show_exceptions"=>false, "action_dispatch.show_detailed_exceptions"=>true, "action_dispatch.logger"=>#<ActiveSupport::Logger:0x007ff5f4ae9240 @progname=nil, @level=0, @default_formatter=#<Logger::Formatter:0x007ff5f4ae9088 @datetime_format=nil>, @formatter=#<ActiveSupport::Logger::SimpleFormatter:0x007ff5f73d14c8 @datetime_format=nil>, @logdev=#<Logger::LogDevice:0x007ff5f4ae8818 @shift_size=nil, @shift_age=nil, @filename=nil, @dev=#<File:/Users/jakewendt/github_repo/ccls/clic/log/test.log>, @mutex=#<Logger::LogDevice::LogDeviceMutex:0x007ff5f4ae87c8 @mon_owner=nil, @mon_count=0, @mon_mutex=#<Mutex:0x007ff5f4ae8728>>>>, "action_dispatch.backtrace_cleaner"=>#<Rails::BacktraceCleaner:0x007ff5f72c19e8 @filters=[#<Proc:0x007ff5f72c9fd0@/opt/local/lib/ruby2.0/gems/2.0.0/gems/railties-4.1.6/lib/rails/backtrace_cleaner.rb:10>, #<Proc:0x007ff5f72c9d00@/opt/local/lib/ruby2.0/gems/2.0.0/gems/railties-4.1.6/lib/rails/backtrace_cleaner.rb:11>, #<Proc:0x007ff5f72c9b98@/opt/local/lib/ruby2.0/gems/2.0.0/gems/railties-4.1.6/lib/rails/backtrace_cleaner.rb:12>, #<Proc:0x007ff5f72d3ee0@/opt/local/lib/ruby2.0/gems/2.0.0/gems/railties-4.1.6/lib/rails/backtrace_cleaner.rb:24>], @silencers=[#<Proc:0x007ff5f72d3eb8@/opt/local/lib/ruby2.0/gems/2.0.0/gems/railties-4.1.6/lib/rails/backtrace_cleaner.rb:15>, #<Proc:0x007ff5f72d3cd8@/opt/local/lib/ruby2.0/gems/2.0.0/gems/jakewendt-test_with_verbosity-0.0.4/lib/test_with_verbosity.rb:155>]>, "action_dispatch.key_generator"=>#<ActiveSupport::CachingKeyGenerator:0x007ff5f6d92df0 @key_generator=#<ActiveSupport::KeyGenerator:0x007ff5f6d92e18 @secret="49f429b460fd8fd912e0f6b81c53c9fa4d1d96b59106249d0a488162bcee1ec76b5b813bd9c5a060222b80d7f0330532e2544d66cc93492160091ea9200d2ff5", @iterations=1000>, @cache_keys=#<ThreadSafe::Cache:0x007ff5f6d92dc8 @backend={}, @default_proc=nil>>, "action_dispatch.http_auth_salt"=>"http authentication", "action_dispatch.signed_cookie_salt"=>"signed cookie", "action_dispatch.encrypted_cookie_salt"=>"encrypted cookie", "action_dispatch.encrypted_signed_cookie_salt"=>"signed encrypted cookie", "action_dispatch.cookies_serializer"=>nil, "rack.session"=>{"user_credentials"=>"627205bffe97084305fb1fd55be01b7f5cc2f4f8b2b56155c92e2073b79ab22aa7a9bd6beb217c3f80465740dadeef6de761900e25c3aec4e7ec205c4565f534", "user_credentials_id"=>1482}, "rack.session.options"=>{:key=>"rack.session", :path=>"/", :domain=>nil, :expire_after=>nil, :secure=>false, :httponly=>true, :defer=>false, :renew=>false, :sidbits=>128, :cookie_only=>true, :secure_random=>SecureRandom, :id=>"eff3ec28c262d3460d16932981f5f182"}, "action_dispatch.request.query_parameters"=>{}, "action_dispatch.cookies"=>#<ActionDispatch::Cookies::CookieJar:0x007ff5f34948a0 @key_generator=#<ActiveSupport::CachingKeyGenerator:0x007ff5f6d92df0 @key_generator=#<ActiveSupport::KeyGenerator:0x007ff5f6d92e18 @secret="49f429b460fd8fd912e0f6b81c53c9fa4d1d96b59106249d0a488162bcee1ec76b5b813bd9c5a060222b80d7f0330532e2544d66cc93492160091ea9200d2ff5", @iterations=1000>, @cache_keys=#<ThreadSafe::Cache:0x007ff5f6d92dc8 @backend={}, @default_proc=nil>>, @set_cookies={}, @delete_cookies={}, @host="test.host", @secure=false, @options={:signed_cookie_salt=>"signed cookie", :encrypted_cookie_salt=>"encrypted cookie", :encrypted_signed_cookie_salt=>"signed encrypted cookie", :secret_token=>nil, :secret_key_base=>"49f429b460fd8fd912e0f6b81c53c9fa4d1d96b59106249d0a488162bcee1ec76b5b813bd9c5a060222b80d7f0330532e2544d66cc93492160091ea9200d2ff5", :upgrade_legacy_signed_cookies=>false, :serializer=>nil}, @cookies={}, @committed=false>, "rack.request.cookie_hash"=>{}, "action_dispatch.request.path_parameters"=>{"id"=>"113", "controller"=>"questionnaires", "action"=>"download"}, "action_dispatch.request.content_type"=>nil, "action_dispatch.request.request_parameters"=>{}, "action_dispatch.request.flash_hash"=>#<ActionDispatch::Flash::FlashHash:0x007ff5f349da68 @discard=#<Set: {}>, @flashes={}, @now=nil>, "PATH_INFO"=>"/questionnaires/113/download", "action_dispatch.request.parameters"=>{"id"=>"113", "controller"=>"questionnaires", "action"=>"download"}, "action_dispatch.request.formats"=>[#<Mime::Type:0x007ff5f6975ba0 @synonyms=["application/xhtml+xml"], @symbol=:html, @string="text/html">]}, @symbolized_path_params={:id=>"113", :controller=>"questionnaires", :action=>"download"}, @filtered_parameters={"id"=>"113", "controller"=>"questionnaires", "action"=>"download"}, @filtered_env=nil, @filtered_path=nil, @protocol="http://", @port=80, @method="GET", @request_method="GET", @remote_ip=nil, @original_fullpath=nil, @fullpath="/questionnaires/113/download", @ip=nil, @uuid=nil, @cookies={}, @formats=nil, @set_cookies={}>>


