require 'rails_helper'

RSpec.feature 'Signed in user can view all his urls' do
  let(:user) { FactoryGirl.create(:user) }
  let(:first_url) { FactoryGirl.build(:url, original: 'first') }
  let(:second_url) { FactoryGirl.build(:url, original: 'second') }
  let(:third_url) { FactoryGirl.build(:url, original: 'third') }

  scenario 'successully' do
    login_as user
    [first_url, second_url, third_url].each do |url|
      visit '/'
      fill_in 'Original url', with: url.original
      click_button 'Submit'
    end
    click_link 'View all urls'
    
    expect(page).to have_content first_url.original
    expect(page).to have_content second_url.original
    expect(page).to have_content third_url.original
  end
end
