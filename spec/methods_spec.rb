require 'spec_helper'

describe YandexApiDirect::DirectService do
  it { is_expected.to respond_to(:compaigns) }

  before do
    YandexApiDirect.reset_configuration
  end

  describe 'methods proxy' do
    let (:service) { YandexApiDirect.service }
    let (:default_response_body) { {:result => {:test => 'yes'} } }

    it 'should allow to call API methods using resource.method notation' do
      expect(service.campaigns).to respond_to(:get, :update, :delete)
    end

    it 'should perform API request on method call with params' do
			params = {
				'SelectionCriteria': {},
				'FieldNames': ['Id']
			}
			stub_request(:post, 'https://api.direct.yandex.com/json/v5/compaigns').to_return(:status => 200, :body => default_response_body.to_json)
      service.compaigns.get(params)
      expect(WebMock).to have_requested(:post, 'https://api.direct.yandex.com/json/v5/compaigns')
				.with(body: {
					'method': 'get',
					'params': params
				}.to_json)
    end

    describe 'configuration' do
      it { is_expected.to respond_to(:configuration) }

      before do
        YandexApiDirect.configure do |conf|
          conf.app_id = '0123456789'
          conf.access_token = '0123456789abcdef'
        end
      end

      it 'should use global configuration by default' do
        service = YandexApiDirect.service
        expect(service.configuration).to eq(YandexApiDirect.configuration)
      end

      it 'should provide direct access to configuration fields' do
        service = YandexApiDirect.service
        expect(service.app_id).to eq('0123456789')
        expect(service.access_token).to eq('0123456789abcdef')
      end

      it 'should be ready that configuration will be nil' do
        YandexApiDirect.reset_configuration
        service = YandexApiDirect.service
        expect(service.configuration).to be nil
        expect(service.app_id).to be nil
        expect(service.access_token).to be nil
      end
    end
  end
end
