require 'spec_helper'

describe YandexApiDirect::DirectService do
  it { should respond_to(:call) }
  it { should respond_to(:method_url) }
  it { should respond_to(:http) }

  let (:service) { YandexApiDirect.service }
  let (:default_response_body) { {:result => {:test => 'yes'} } }
	let (:request_params) { params = {'SelectionCriteria': {}, 'FieldNames': ['Id'] }}

  before do
    YandexApiDirect.reset_configuration
  end

  describe '#method_url' do
    it 'should raise ArgumentError when method name is nil' do
      expect{ service.method_url(nil) }.to raise_error(ArgumentError, 'Method name could not be empty')
    end

    it 'should raise ArgumentError when method name is empty string' do
      expect{ service.method_url('') }.to raise_error(ArgumentError, 'Method name could not be empty')
    end

    it 'should take care of method name' do
      expect(service.method_url('campaigns')).to eq('https://api.direct.yandex.com/json/v5/campaigns')
    end
  end

  describe '#http' do
    it 'should return result of block call' do
			stub_request(:post, 'https://api.direct.yandex.com/json/v5/compaigns').to_return(:status => 200, :body => default_response_body.to_json)
      expect(service.http('compaigns', request_params) { |_| 'calculate result'}).to eq('calculate result')
    end

    it 'should pass http connection as parameter into block' do
			stub_request(:post, 'https://api.direct.yandex.com/json/v5/compaigns').to_return(:status => 200, :body => default_response_body.to_json)
      expect(service.http('compaigns', request_params) { |http| http }).to be_a(Net::HTTPResponse)
    end
  end

  describe '#call' do
		it 'should setup appropriate headers' do
			stub_request(:post, "https://api.direct.yandex.com/json/v5/campaigns")
        .to_return(:status => 200, :body => default_response_body.to_json)

      service.call('campaigns', {
				'method' => 'get',
				'params' => request_params
			})

      expect(WebMock).to have_requested(:post, 'https://api.direct.yandex.com/json/v5/campaigns')
				.with(body: {
					'method' => 'get',
					'params' => request_params
				}.to_json)
				.with(:headers => {
					'Content-Type' => 'application/json; charset=utf-8'
				})
    end

    it 'should send request to appropriate url according to method name' do
			stub_request(:post, "https://api.direct.yandex.com/json/v5/campaigns")
        .to_return(:status => 200, :body => default_response_body.to_json)

      service.call('campaigns', {
				'method' => 'test',
				'params' => request_params
			})

      expect(WebMock).to have_requested(:post, 'https://api.direct.yandex.com/json/v5/campaigns')
				.with(body: {
					'method' => 'test',
					'params' => request_params
				}.to_json)
    end

    it 'should send request to appropriate url according params' do
			stub_request(:post, "https://api.direct.yandex.com/json/v5/campaigns")
        .to_return(:status => 200, :body => default_response_body.to_json)

      service.call('campaigns', {
				'method' => 'test',
				'params' => request_params.merge(test: 'test')
			})

      expect(WebMock).to have_requested(:post, 'https://api.direct.yandex.com/json/v5/campaigns')
				.with(body: {
					'method' => 'test',
					'params' => request_params.merge(test: 'test')
				}.to_json)
    end

    it 'should return raise MethodCallError if body of response is nil' do
			stub_request(:post, 'https://api.direct.yandex.com/json/v5/campaigns')
        .to_return(:status => 200, :body => nil)
      expect {
				service.call('campaigns', {
					'method' => 'get',
					'params' => request_params
				})
			}.to raise_error(YandexApiDirect::MethodCallError, 'Response could not be empty')
    end

    it 'should return raise MethodCallError if body of response is empty string' do
			stub_request(:post, 'https://api.direct.yandex.com/json/v5/campaigns')
        .to_return(:status => 200, :body => '')
      expect {
				service.call('campaigns', {
					'method' => 'get',
					'params' => request_params
				})
			}.to raise_error(YandexApiDirect::MethodCallError, 'Response could not be empty')
    end

    it 'should return raise MethodCallError if body of response has no key :result' do
			stub_request(:post, 'https://api.direct.yandex.com/json/v5/campaigns')
        .to_return(:status => 200, :body => { :bad => :response }.to_json)
      expect {
				service.call('campaigns', {
					'method' => 'get',
					'params' => request_params
				})
			}.to raise_error(YandexApiDirect::MethodCallError, 'Response should include key named :result')
    end

    it 'should raise MethodCallError error in case of internal server error' do
			stub_request(:post, 'https://api.direct.yandex.com/json/v5/campaigns')
        .to_return(:status => 500, :body => 'Internal Server Error')
      expect {
				service.call('campaigns', {
					'method' => 'get',
					'params' => request_params
				})
			}.to raise_error(YandexApiDirect::MethodCallError, 'Internal Server Error')
    end

    it 'should raise MethodCallError in case of method call error' do
			response = { :error => { :error_code => 54, :error_string => 'No rights', :error_detail => 'No rights to indicated client' } }
			stub_request(:post, 'https://api.direct.yandex.com/json/v5/campaigns')
        .to_return(:status => 200, :body => response.to_json)
      expect {
				service.call('campaigns', {
					'method' => 'get',
					'params' => request_params
				})
			}.to raise_error(YandexApiDirect::MethodCallError, response.to_json)
    end

    it 'should return value of :result key of returned json' do
			stub_request(:post, 'https://api.direct.yandex.com/json/v5/campaigns')
        .to_return(:status => 200, :body => default_response_body.to_json)
      expect(
				service.call('campaigns', {
					'method' => 'get',
					'params' => request_params
				})
			).to eq(default_response_body[:result])
    end
  end
end
