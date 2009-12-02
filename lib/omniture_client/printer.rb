module OmnitureClient
  module Printer
    def to_js
      var_types.inject("") do |js, var_type|
        send(var_type).each do |var|
          js << var_to_js(var)
        end
      end
    end

    def to_query
      var_types.inject("") do |query, var_type|
        send(var_type).each do |var|      
          query << var_to_query(var)
        end
      end
    end

    private

    def var_to_query(var)
      send(var).to_query(var) + '&' if send(var)
    end

    def var_to_js(var)
      "var #{var} = '#{send(var).gsub()}'; " if send(var)
    end

  end
end
