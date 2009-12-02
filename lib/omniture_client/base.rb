module OmnitureClient
  class Base
    
    include Printer

    attr_reader  :controller

    @var_groups = []

    def initialize(controller)
      @controller = controller
    end

    def printer
      @printer ||= Printer.new(self)
    end

    def vars
      @vars ||= self.class.var_groups.inject([]) do |vars, grp|
        vars << grp.values(controller) if grp
        vars
      end
    end

    def add_var(name, value)
      vars << Var.new(name, value)
    end

    class << self
      attr_reader :var_groups

      def define_var(name, &block)
        var_group = instance_eval("@#{name} ||= VarGroup.new(name)")
        var_group.add_var(block)
        var_groups << var_group unless var_groups.include?(var_group)
        var_group
      end
    end
  end
end
