#
# commented this out as no longer using Sunspot/Solr.
#
#begin
##  don't think that this works in the jruby world
# Sunspot::Rails::Server.new.start
#rescue Sunspot::Server::AlreadyRunningError
#end

module SunspotTestHelper
end

class ActiveSupport::TestCase

# def self.assert_should_be_searchable
#   # This does NOT test searching, it just allows testing while searchable
#   test "should be searchable" do
##      Sunspot.index!
#     Sunspot.remove_all!
#     assert model_name.constantize.respond_to?(:search)
#     search = model_name.constantize.search
#     assert search.facets.empty?
#     assert search.hits.empty?
#     assert search.results.empty?
#   end
# end

end
