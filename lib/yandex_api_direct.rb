require 'net/http'
require 'json'

module YandexApiDirect
  autoload :Configuration, "yandex_api_direct/configuration"
  autoload :Call, "yandex_api_direct/call"
  autoload :Methods, "yandex_api_direct/methods"

  class MethodCallError < StandardError; end;

  class DirectService
    include YandexApiDirect::Call
    include YandexApiDirect::Methods

    def initialize(configuration = nil)
      @configuration = configuration
    end

    def configuration
      @configuration || YandexApiDirect.configuration
    end

    def app_id
      configuration.app_id unless configuration.nil?
    end

    def base_url
      if configuration.nil?
        YandexApiDirect::Configuration::BASE_URL_DEFAULT
      else
        configuration.base_url
      end
    end

    def access_token
      configuration.access_token unless configuration.nil?
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= self::Configuration.new
    yield(configuration)
  end

  def self.reset_configuration
    self.configuration = nil
  end

  def self.service
    self::DirectService.new
  end
end
