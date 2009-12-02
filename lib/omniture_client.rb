module OmnitureClient
  def import_aliases(alias_hash)
    @alias_hash = alias_hash
  end

  attr_reader :alias_hash

  module ControllerMethods
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def report_to(reporter)
        include InstanceMethods
        @reporter = reporter
      end

      def reporter
        @reporter
      end
    end

    module InstanceMethods
      def reporter
        if self.class.reporter.is_a?(Class)
          @reporter ||= reporter
        elsif self.class.reporter.is_a?(Proc)
          @reporter ||= reporter.call
        end
      end

      def omniture_js
        reporter.to_js
      end

      def omniture_url
        reporter.to_query 
      end
    end
  end
end
