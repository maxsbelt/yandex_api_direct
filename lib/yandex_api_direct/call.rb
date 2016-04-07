module YandexApiDirect
	module Call
		def call(method_name, params = {})
			http(method_name, params) do |response|
        raise YandexApiDirect::MethodCallError, response.body unless response.is_a?(Net::HTTPSuccess)
        json = response.body
        raise YandexApiDirect::MethodCallError, 'Response could not be empty' if json.nil? || json.empty?
				parsed_json = JSON.parse(json, symbolize_names: true)
        raise YandexApiDirect::MethodCallError, json if is_error?(parsed_json)
        raise YandexApiDirect::MethodCallError, 'Response should include key named :result' unless parsed_json.has_key?(:result)
				parsed_json[:result]
      end
		end

		def http(method_name, params = {})
      uri = URI(method_url(method_name))
      req = Net::HTTP::Post.new(uri, headers)
			req.body = params.to_json
      yield (
				Net::HTTP.start(uri.hostname, uri.port, use_ssl: true).request(req)
			)
    end

		def method_url(method_name)
      if method_name.nil? || method_name.empty?
        raise ArgumentError, 'Method name could not be empty'
      end
      "#{base_url}/#{method_name}"
    end

		def is_error?(parsed_json)
      parsed_json.has_key?(:error)
    end

		def headers
			{
				'Authorization' => "Bearer #{access_token}",
				'Content-Type' => 'application/json; charset=utf-8'
			}
		end
	end
end
