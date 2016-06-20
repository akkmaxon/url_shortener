require 'rails_helper'

RSpec.feature 'User can delete urls' do
  let(:user) { FactoryGirl.create(:user) }
  let!(:url) { FactoryGirl.create(:url, user_id: user.id) }
  let!(:common_url) { FactoryGirl.create(:url, short: "#{url}a") }

  before do
    login_as(user)
    visit '/urls'
  end

  scenario 'page loads properly' do
    expect(page).to have_css "input##{url.short}"
    expect(page).to have_link 'Delete'
  end

  scenario 'successfully' do
    click_link 'Delete'
    expect(page).to have_content 'Url has been deleted'
    visit '/urls'
    expect(page).to_not have_content "/#{url.short}"
  end

  context 'unsuccessfully' do
    before do
      click_link 'Sign out'
    end

    scenario 'anonymous user cannot view delete links' do
      make_search_request url.short, 'Short URL'
      within '.list-group' do
	expect(page).to_not have_link 'Delete'
      end
    end

    scenario 'other user can view only own delete links' do
      other_user = FactoryGirl.create(:user, email: 'alien@example.com')
      other_url = FactoryGirl.create(:url, short: "#{url.short}a", user_id: other_user.id)

      login_as(other_user)
      make_search_request url.short, 'Short URL'

      within '.list-group' do
	expect(page).to have_content url.original
	expect(page).to have_content common_url.original
	expect(page).to have_content other_url.original
	edit_links = all('.pull-right a').select {|a| a.text == 'Delete' }
	expect(edit_links.size).to eq 1
      end
    end
  end
end
