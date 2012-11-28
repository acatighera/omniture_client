module OmnitureClient
  class MetaVar
    attr_reader :name, :delimiter
    attr_accessor :value_procs

    def initialize(name, delimiter)
      @name = name
      @value_procs = []
      @delimiter = delimiter
    end

    def add_var(value_proc)
      value_procs << value_proc
    end

    def value(scope)
      if self.name == 'events'
        Var.new(name, value_procs.map{ |p| scope.instance_eval(&p) }.flatten.uniq.join(delimiter))
      else
        Var.new(name, value_procs.last(1).map{ |p| scope.instance_eval(&p) }.flatten.uniq.join(delimiter))
      end
    end
  end
end
