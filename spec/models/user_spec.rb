require 'rails_helper'

RSpec.describe User do

  it 'successfully create user' do
    user = FactoryGirl.build(:user)
    expect(user).to be_valid
  end

  context "don't create user" do
    let(:blank_email_error) { "Email can't be blank" }
    let(:blank_password_error) { "Password can't be blank" }
    let(:password_confirmation_wrong) { "Password confirmation doesn't match Password" }
    let(:short_password_error) { 'Password is too short (minimum is 6 characters)' }

    it 'if all properties are empty' do
      user = FactoryGirl.build(:user, email: '', password: '', password_confirmation: '')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to contain_exactly(blank_email_error,
							   blank_password_error)
    end

    it 'if email is empty' do
      user = FactoryGirl.build(:user, email: '')
      expect(user).to_not be_valid
      expect(user.errors.size).to eq 1
      expect(user.errors.full_messages[0]).to eq(blank_email_error)
    end

    it 'if password is empty' do
      user = FactoryGirl.build(:user, password: '', password_confirmation: '')
      expect(user).to_not be_valid
      expect(user.errors.size).to eq 1
      expect(user.errors.full_messages[0]).to eq(blank_password_error)
    end

    it 'if password and password confirmation are not equal' do
      user = FactoryGirl.build(:user, password_confirmation: 'abcdefgh')
      expect(user).to_not be_valid
      expect(user.errors.size).to eq 1
      expect(user.errors.full_messages[0]).to eq(password_confirmation_wrong)
    end

    it 'if password\'s size less than 6' do
      password = 'abcde'
      user = FactoryGirl.build(:user, password: password, password_confirmation: password)
      expect(user).to_not be_valid
      expect(user.errors.size).to eq 1
      expect(user.errors.full_messages[0]).to eq(short_password_error)
    end
  end
end
