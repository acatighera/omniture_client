module OmnitureClient
  class Var
    attr_reader :name, :value
    def initialize(name, value)
      @name = name
      if OmnitureClient::aliases && OmnitureClient::aliases[name]
        @name = OmnitureClient::aliases[name]
      else
        @name = name
      end
      @value = value
    end
  end
end
