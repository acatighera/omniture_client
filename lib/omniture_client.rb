require File.dirname(__FILE__) + '/omniture_client/printer'
require File.dirname(__FILE__) + '/omniture_client/base'
require File.dirname(__FILE__) + '/omniture_client/var'
require File.dirname(__FILE__) + '/omniture_client/meta_var'
require File.dirname(__FILE__) + '/omniture_client/controller_methods'
require 'cgi'

class BasicReporter < OmnitureClient::Base; end

module OmnitureClient
  class << self
    attr_accessor :aliases, :base_url, :ssl_url, :suite, :version

    def config(config_hash)
      config_hash.each do |key, val|
        send("#{key}=", val)
      end
    end
  end
end

if defined?(Rails)
  require File.dirname(__FILE__) + '/omniture_rails' 
end
