module OmnitureClient
  module Printer

    def url(ssl = false)
      suite = OmnitureClient::suite.is_a?(Array) ? OmnitureClient::suite.join(',') : OmnitureClient::suite
      base_url =  ssl == :ssl ? OmnitureClient::ssl_url : OmnitureClient::base_url
      "#{base_url}/b/ss/#{suite}/#{OmnitureClient::version}/#{rand(9999999)}?#{query}"
    end

    def query
      vars.inject([]) do |query, var|
        query << var_to_query(var)
      end.join('&')
    end

    private

    def var_to_query(var)
      "#{ CGI::escape(var.name) }=#{ CGI::escape(var.value) }" if var
    end
  end
end
