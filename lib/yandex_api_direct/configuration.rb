module YandexApiDirect
  class Configuration
    BASE_URL_DEFAULT = "https://api.direct.yandex.com/json/v5".freeze

    attr_accessor :app_id
    attr_accessor :access_token
    attr_accessor :base_url

    def initialize(options = {})
      @app_id = options[:app_id]
      @access_token = options[:access_token]
      @base_url =  options.fetch(:base_url, YandexApiDirect::Configuration::BASE_URL_DEFAULT)
    end
  end
end
