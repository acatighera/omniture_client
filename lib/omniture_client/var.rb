module OmnitureClient
  class Var
    attr_reader :name, :value
    def initialize(name, value)
      @name = name
      if OmnitureClient::alias_hash && OmnitureClient::alias_hash[name]
        @name = OmnitureClient::alias_hash[name]
      else
        @name = name
      end
      @value = value
    end
  end
end
