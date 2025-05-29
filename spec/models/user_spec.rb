require 'rails_helper'

RSpec.describe User, type: :model do
  # Configure memory store for testing
  before(:all) do
    Rails.cache = ActiveSupport::Cache::MemoryStore.new
  end

  after(:each) do
    Rails.cache.clear
  end

  describe 'validations' do
    it 'requires an email' do
      user = User.new(password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires email to be unique' do
      existing_user = User.create!(email: 'test@example.com', password: 'password123')
      user = User.new(email: 'test@example.com', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end
  end

  describe '#reset_session_token!' do
    it 'updates the session token' do
      user = User.create!(email: 'test@example.com', password: 'password123')
      old_token = user.session_token
      user.reset_session_token!
      expect(user.session_token).not_to eq(old_token)
      expect(user.session_token).to be_present
    end
  end

  describe '#subscription_status' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
    let(:cache_key) { "user_subscription_status/#{user.id}" }
    let(:billing_service) { instance_double(BillingApiService) }

    before do
      allow(BillingApiService).to receive(:new).with(user.id).and_return(billing_service)
    end

    context 'when status is cached' do
      before do
        Rails.cache.write(cache_key, 'active', expires_in: 24.hours)
      end

      it 'returns cached status' do
        expect(billing_service).not_to receive(:fetch_subscription_status)
        expect(user.subscription_status).to eq('active')
      end
    end

    context 'when status is not cached' do
      before do
        Rails.cache.delete(cache_key)
        allow(billing_service).to receive(:fetch_subscription_status)
          .and_return({ 'subscription_status' => 'expired' })
      end

      it 'fetches fresh status and caches it' do
        expect(user.subscription_status).to eq('expired')
        expect(Rails.cache.read(cache_key)).to eq('expired')
      end
    end

    context 'when status is unavailable' do
      before do
        Rails.cache.write(cache_key, 'unavailable')
        allow(billing_service).to receive(:fetch_subscription_status)
          .and_return({ 'subscription_status' => 'expired' })
      end

      it 'fetches fresh status' do
        expect(user.subscription_status).to eq('expired')
      end
    end
  end
end
