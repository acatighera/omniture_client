module OmnitureClient
  module ActionControllerMethods

    def self.included(base)
      base.send(:before_filter, :report_omniture_if_events_in_flash)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      attr_accessor :reporter
    end

    module ClassMethods
      def reports_to_omniture(options = {})
        before_filter :set_reporter, options
      end
    end

    module InstanceMethods

      def omniture_flash
        @omniture_flash ||= (flash[:omniture] || {})
      end

      def omniture_url
        ssl = :ssl if request.ssl? && OmnitureClient::ssl_url
        self.reporter.url(ssl)
      end

      private

      def set_reporter
        self.reporter = select_reporter
        report_omniture_if_events_in_flash
      end

      def select_reporter
        begin
           "#{controller_path.classify}Reporter".constantize.new(self)
        rescue NameError
           BasicReporter.new(self)
        end
      end

      def report_omniture_if_events_in_flash
        if flash[:omniture] && flash[:omniture][:events]
          if self.class.respond_to?(:reports_to_omniture) && defined?(self.class::OMNITURE_ACTIONS) && !self.class::OMNITURE_ACTIONS.include?(action_name)
            self.reporter ||= select_reporter
            assign_flash_vars
          end
        end
      end

      def assign_flash_vars
        omniture_flash.each do |name, value|
          self.reporter.add_var(name, value)
        end
        flash[:omniture].clear if omniture_flash.present?
      end
    end
  end
end

ActionController::Base.send(:include, OmnitureClient::ActionControllerMethods) if defined?(ActionController::Base)

OmnitureClient::config(YAML::load(File.open('config/omniture.yml'))[Rails.env]) if File.exists?('config/omniture.yml')
