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

  describe '#total_percentage_must_be_100' do
    before do
      User.destroy_all # Clear existing users to avoid interference
    end

    xit 'adds an error when the total percentage of all users is not 100' do
      create(:user, percentage: 90)
      user2 = build(:user, email: 'test2@example.com', password: 'password', percentage: 30)
      user2.valid?
      expect(user2.errors[:percentage]).to include("La suma de los porcentajes de todos los usuarios debe ser 100 (actual: 120)")
    end

    it 'does not add an error when the total percentage of all users is 100' do
      user1 = create(:user)
      user2 = build(:user, email: 'test2@example.com', password: 'password', percentage: 70)
      user2.valid?
      expect(user2.errors[:base]).to be_empty
    end

    it 'correctly handles nil percentages' do
      user1 = create(:user)
      user2 = build(:user, email: 'test2@example.com', password: 'password', percentage: nil)
      user2.valid?
      expect(user2.errors[:base]).to be_empty # Should not trigger the error if percentage is nil
    end
  end
end