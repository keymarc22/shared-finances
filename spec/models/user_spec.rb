require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'devise modules' do
    it 'includes database_authenticatable' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable' do
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe 'associations' do
    it 'has many expenses with dependent destroy' do
      assoc = User.reflect_on_association(:expenses)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end

    it 'has many incomings with dependent destroy' do
      assoc = User.reflect_on_association(:incomings)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end

    it 'has many savings_plans with dependent destroy' do
      assoc = User.reflect_on_association(:savings_plans)
      expect(assoc.macro).to eq(:has_many)
    end

    it 'has many budgets with dependent destroy' do
      assoc = User.reflect_on_association(:budgets)
      expect(assoc.macro).to eq(:has_many)
    end
  end
end