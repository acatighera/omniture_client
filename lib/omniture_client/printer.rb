module OmnitureClient
  module Printer

    def url

    end

    def to_query
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
