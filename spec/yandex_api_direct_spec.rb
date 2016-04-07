require 'spec_helper'

describe YandexApiDirect do
  describe 'configuration' do
    it { is_expected.to respond_to(:configure) }

    before do
      YandexApiDirect.configure do |conf|
        conf.app_id = '0123456789'
        conf.access_token = '0123456789abcdef'
      end
    end

    it 'should allow to reset configuration' do
      YandexApiDirect.reset_configuration
      expect(YandexApiDirect.configuration).to be nil
    end

    it 'should allow to read global configuration' do
      expect(YandexApiDirect.configuration.app_id).to eq('0123456789')
      expect(YandexApiDirect.configuration.access_token).to eq('0123456789abcdef')
    end
  end
end
