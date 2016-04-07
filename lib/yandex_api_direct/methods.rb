module YandexApiDirect
  module Methods
    def method_missing(method_name, *arguments, &block)
      Proxy.new(self, method_name)
    end

    def respond_to?(method_name, include_private = false)
      true # we should respond to any method using Proxy
    end

    class Proxy
      attr_accessor :service
      attr_accessor :resource

      def initialize(service, resource)
        @service = service
        @resource = resource
      end

      def method_missing(method_name, *arguments, &block)
				service.call(resource, method: method_name, params: arguments.first)
      end

      def respond_to?(method_name, include_private = false)
        true # we should respond to any method using Proxy
      end
    end
  end
end
