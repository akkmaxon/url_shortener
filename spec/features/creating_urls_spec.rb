require 'rails_helper'

RSpec.feature 'Users can create urls' do
  let(:url) { FactoryGirl.build(:url) }
  before do
    visit '/'
  end

  scenario 'filling all inputs' do
    fill_in 'Original url', with: url.original
    fill_in 'Short url(optional)', with: url.short
    # TODO implement later
    # click_button 'Add description'
    fill_in 'Description', with: url.description
    click_button 'Submit'
    expect(page).to have_content 'Short link has been created'
  end

  scenario 'submitting empty fields' do
    click_button 'Submit'
    expect(page).to have_content "Original URL can't be blank"
  end

  scenario 'fill only optional fields' do
    fill_in 'Short url(optional)', with: url.short
    # TODO implement later
    # click_button 'Add description'
    fill_in 'Description', with: url.description
    click_button 'Submit'
    expect(page).to have_content "Original URL can't be blank"
  end
end
