require File.dirname(__FILE__) + '/omniture_client/base'
require File.dirname(__FILE__) + '/omniture_client/var'
require File.dirname(__FILE__) + '/omniture_client/meta_var'
require File.dirname(__FILE__) + '/omniture_client/controller_methods'
if defined?(Rails)
  require File.dirname(__FILE__) + '/rails' 
end

class BasicReporter < OmnitureClient::Base; end

module OmnitureClient
  def self.import_aliases(alias_hash)
    @alias_hash = alias_hash
  end
  
  def self.alias_hash
    @alias_hash
  end
end
