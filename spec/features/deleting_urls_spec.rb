require 'rails_helper'

RSpec.feature 'User can delete urls' do
  let(:user) { FactoryGirl.create(:user) }
  let!(:own_url) { FactoryGirl.create(:url, user_id: user.id) }
  let!(:common_url) { FactoryGirl.create(:url, short: 'unique') }

  before do
    login_as(user)
    visit '/urls'
  end

  scenario 'page loads properly' do
    expect(page).to have_content "/#{own_url.short}"
    expect(page).to have_link 'Delete'
  end

  scenario 'successfully' do
    click_link 'Delete'
    expect(page).to have_content 'Url has been deleted'
    visit '/urls'
    expect(page).to_not have_content "/#{own_url.short}"
  end

  scenario 'unsuccessfully' do
    expect(page).to_not have_content "/#{common_url.short}"
  end
end
