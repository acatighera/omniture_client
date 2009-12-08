module OmnitureClient
  class Var
    attr_reader :name, :value
    def initialize(name, value)
      if OmnitureClient::aliases && OmnitureClient::aliases[name.to_s]
        @name = OmnitureClient::aliases[name.to_s]
      else
        @name = name.to_s
      end
      @value = value
    end
  end
end
