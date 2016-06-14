require 'rails_helper'

RSpec.feature 'User can edit his urls' do
  let(:user) { FactoryGirl.create(:user) }
  let!(:url) { FactoryGirl.create(:url, user_id: user.id) }
  let(:new_url) { FactoryGirl.build(:url, original: '/some/thing/new',
				          short: 'newtoo',
				          description: 'Describe it differently') }
  before do
    login_as(user)
    visit '/urls'
    click_link 'Edit'
  end
  
  context 'successfully' do

    scenario 'page loads properly' do
      expect(page).to have_content 'Edit Url'
      expect(page).to have_css 'form'
    end

    scenario 'with changes in all fields' do
      fill_in 'Original url', with: new_url.original
      fill_in 'Short url(optional)', with: new_url.short
      fill_in 'Description', with: new_url.description
      click_button 'Submit'

      expect(page).to have_content 'Short link has been updated'
      expect(page).to have_content "/#{new_url.short}"
      expect(new_url).to_not be_valid
    end

    scenario 'without any changes' do
      click_button 'Submit'
      expect(page).to have_content 'Short link has been updated'
      expect(page).to have_content "/#{url.short}"
      expect(page).to_not have_content "/#{new_url.short}"
      expect(new_url).to be_valid
    end
  end

  context 'unsuccessfully' do
    scenario 'cannot be reached by anonymous users' do
      click_link 'Sign out'
      visit "/urls/#{url.id}/edit"
      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end

    scenario 'with empty original url' do
      fill_in 'Original url', with: ''
      click_button 'Submit'
      expect(page).to have_content 'Original URL can\'t be blank'
    end

    scenario 'if short url is not unique' do
      new_url.save
      fill_in 'Short url(optional)', with: new_url.short
      click_button 'Submit'
      expect(page).to have_content 'Short URL has already been taken'
    end
  end
end
