module OmnitureClient
  module ActionControllerMethods
    def reports_to_omniture
      include ControllerMethods

      before_filter do
        omniture_flash.each do |name, value|
          reporter.add_var(name, value)
        end
      end

      report_to lambda {
        begin
          "#{controller_path.classify}Reporter".constantize.new(self)
        rescue
          BasicReporter.new(self)
        end
      }
    
      define_method :omniture_flash do
        flash[:omniture] ||= {}
      end
    end
  end
end

if is_defined?(ApplicationController)
  ApplicationController.extend(ActionControllerMethods)
  ApplicationController.reports_to_omniture
end

