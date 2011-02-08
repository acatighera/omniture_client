module OmnitureClient
  class Base
    
    include Printer

    attr_reader  :controller

    @meta_vars = []

    def initialize(controller)
      @controller = controller
    end

    def printer
      @printer ||= Printer.new(self)
    end

    def vars
      meta_vars = self.class.meta_vars || [] 
      @vars ||= meta_vars.inject([]) do |vars, meta_var|
        vars << meta_var.value(controller) if meta_var
        vars
      end
    end

    def add_var(name, value)
      self.class.var(name) do
        value
      end
    end

    class << self
      attr_reader :meta_vars

      def clear_meta_vars
        if @meta_vars.present?
          @meta_vars.each do |var|
            instance_eval("@#{var.name} = nil")
          end
          @meta_vars = []
        end
      end

      def var(name, delimiter = ',', &block)
        @meta_vars ||= []
        meta_var = instance_eval("@#{name} ||= OmnitureClient::MetaVar.new('#{name}', '#{delimiter}')")
        meta_var.add_var(block)
        meta_vars << meta_var unless meta_vars.include?(meta_var)
        meta_var
      end
    end
  end
end
