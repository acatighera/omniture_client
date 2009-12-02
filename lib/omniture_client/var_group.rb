module OmnitureClient
  class VarGroup
    attr_reader :name
    attr_accessor :value_procs

    def initialize(name)
      @name = name
      @value_procs = []
      @composite = composite
    end

    def add_var(value_proc)
      value_procs << value_proc
    end

    def value(scope)
      Var.new(name, value_procs.map{ |p| scope.instance_eval(p) })
    end

    private

    attr_reader :composite
  end
end
