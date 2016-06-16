require 'rails_helper'

RSpec.feature 'User can read about app' do
  scenario 'pushing "about" link' do
    visit '/'
    click_link 'About'
    within '#about' do
      expect(page).to have_content 'https://goo.gl'
      expect(page).to have_content 'This is Url Shortener'
    end
  end
end
