module YandexApiDirect
  class Configuration
		BASE_URL_DEFAULT = "https://api.direct.yandex.com/json/v5".freeze

    attr_accessor :app_id
    attr_accessor :access_token
		attr_accessor :base_url

		def initialize
			@base_url = YandexApiDirect::Configuration::BASE_URL_DEFAULT
		end
	end
end
