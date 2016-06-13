require 'rails_helper'

RSpec.feature 'Users can create urls' do
  context 'anonymously' do
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
      expect(page).to have_content "/#{url.short}"
      expect(url.user).to eq nil
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

    scenario '' do
      new_url = FactoryGirl.create(:url, short: 'newvalue')
      fill_in 'Original url', with: new_url.original
      fill_in 'Short url(optional)', with: new_url.short
      fill_in 'Description', with: new_url.description
      click_button 'Submit'
      expect(page).to have_content 'Short URL has already been taken'
    end
  end

  context 'when they are logged in' do
    let(:user) { FactoryGirl.create(:user) }
    let(:url) { FactoryGirl.build(:url) }

    scenario 'successfully' do
      login_as(user)
      expect(user.urls.count).to eq 0

      visit '/'
      fill_in 'Original url', with: url.original
      fill_in 'Short url(optional)', with: url.short
      click_button 'Submit'

      expect(page).to have_content 'Short link has been created'
      expect(page).to have_content "/#{url.short}"
      expect(user.urls.count).to eq 1
    end
  end
end
