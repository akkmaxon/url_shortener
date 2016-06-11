require 'rails_helper'

RSpec.feature 'Sign up' do
  scenario 'with valid details' do
    visit '/'
    click_link 'Sign up'
    fill_in 'Email', with: 'user@mail.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
    expect(page).to have_link 'Sign out'
    expect(page).to_not have_link 'Sign in'
    expect(page).to_not have_link 'Sign up'
  end

  scenario 'with invalid details' do
    visit '/'
    click_link 'Sign up'
    fill_in 'Email', with: ''
    fill_in 'Password', with: 'foo'
    fill_in 'Password confirmation', with: 'bar'
    click_button 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password is too short"
    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).to_not have_link 'Sign out'
  end
end

RSpec.feature 'Sign in' do
  let(:user) { FactoryGirl.create(:user) }

  scenario 'with valid credentials' do
    visit '/'
    click_link 'Log in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content "Signed in as #{user.email}"
    expect(page).to have_link 'Sign out'
    expect(page).to_not have_link 'Sign in'
    expect(page).to_not have_link 'Sign up'
  end

  scenario 'with invalid credentials' do
    visit '/'
    click_link 'Log in'
    fill_in 'Email', with: ''
    fill_in 'Password', with: 'not valid'
    click_button 'Log in'
    
    expect(page).to have_content 'Invalid email or password'
    expect(page).to_not have_link 'Sign out'
  end
end

RSpec.feature 'Sign out' do
  let(:user) { FactoryGirl.create(:user) }

  scenario 'successfully' do
    login_as user
    visit '/'

    expect(page).to have_link 'Sign out'
    
    click_link 'Sign out'

    expect(page).to have_content 'Signed out successfully'
    expect(page).to_not have_link 'Sign out'
  end
end
