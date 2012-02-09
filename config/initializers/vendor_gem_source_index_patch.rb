#	bash-3.2$ warble --trace
#	warble aborted!
#	undefined method `gems' for #<Rails::VendorGemSourceIndex:0xdf8388a>
#	/Users/jakewendt/.rvm/gems/jruby-1.5.1/gems/bundler-1.0.22/lib/bundler/rubygems_integration.rb:271:in `all_specs'

module Rails
  class VendorGemSourceIndex
    def gems
      vendor_source_index.gems.merge(installed_source_index.gems)
    end
  end
end
