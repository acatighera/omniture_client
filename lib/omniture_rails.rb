module OmnitureClient
  module ActionControllerMethods

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.send(:before_filter, :set_reporter)#, options
      attr_accessor :reporter
    end

    module ClassMethods
      def reports_to_omniture(options = {})
        # OK
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
        if self.class.respond_to?(:reports_to_omniture) && defined?(self.class::OMNITURE_ACTIONS) &&
           self.class::OMNITURE_ACTIONS.include?(action_name.to_sym)
          self.reporter = select_reporter
        end

        if flash_exists?
          self.reporter ||= select_reporter
          assign_flash_vars
        end
      end

      def select_reporter
        begin
           "#{controller_path.classify}Reporter".constantize.new(self)
        rescue NameError
           BasicReporter.new(self)
        end
      end

      def flash_exists?
        omniture_flash && omniture_flash[:events]
      end

      def assign_flash_vars
        omniture_flash.each do |name, value|
          v = OmnitureClient::MetaVar.new(name.to_s, ',')
          v.add_var(lambda{|s| value})
          self.reporter.flash_vars << v
        end
        if omniture_flash.present?
          flash[:omniture].clear
        end
      end
    end
  end
end

ActionController::Base.send(:include, OmnitureClient::ActionControllerMethods) if defined?(ActionController::Base)

OmnitureClient::config(YAML::load(File.open('config/omniture.yml'))[Rails.env]) if File.exists?('config/omniture.yml')
