require 'rails_helper'

RSpec.describe BillingApiService do
  let(:user_id) { "123" }
  let(:service) { described_class.new(user_id) }

  describe '#fetch_subscription_status', :vcr do
    context 'when the request is successful' do
      it 'returns the parsed response' do
        result = service.fetch_subscription_status
        
        expect(result).to be_a(Hash)
        expect(result).to have_key('subscription_status')
      end
    end

    context 'when the request fails' do
      it 'returns an unavailable status' do
        stub_request(:get, "#{BillingApiService::BASE_URL}/#{user_id}/billing")
          .to_return(status: 500, body: 'Internal Server Error')

        result = service.fetch_subscription_status
        
        expect(result).to eq({ "subscription_status" => "unavailable" })
      end
    end
  end
end
