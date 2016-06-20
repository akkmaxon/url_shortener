require 'rails_helper'

RSpec.feature 'Show urls' do
  let(:user) { FactoryGirl.create(:user) }
  let(:first_url) { FactoryGirl.build(:url, original: 'first', short: 'a1') }
  let(:second_url) { FactoryGirl.build(:url, original: 'second', short: 'a2') }
  let(:third_url) { FactoryGirl.build(:url, original: 'third', short: 'a3') }
  let(:valid_url) { FactoryGirl.create(:url, original: 'https://duckduckgo.com/?q=ruby+on+rails',
					     short: 'rails',
					     description: 'This link is valid') }

  context 'for signed in user' do
    before do
      login_as user
      [first_url, second_url, third_url].each do |url|
	visit '/'
	fill_in 'Original url', with: url.original
	fill_in 'Short url(optional)', with: url.short
	click_button 'Submit'
      end
    end

    scenario '#index' do
      [first_url, second_url, third_url].each do |url|
	expect(page).to have_content url.original
	expect(page).to have_css "input##{url.short}"
      end
    end

    scenario '#show' do
      visit valid_url.short
      expect(page).to have_content 'framework'
    end
  end

  context 'for anonymous user' do
    before do
      [first_url, second_url, third_url].each do |url|
	visit '/'
	fill_in 'Original url', with: url.original
	fill_in 'Short url(optional)', with: url.short
	click_button 'Submit'
      end
    end

    scenario '#index' do
      expect(page).to_not have_link 'View all urls'
      visit '/urls'
      expect(page).to have_content 'You need to sign in or sign up before continuing'
      visit '/'
      expect(page).to have_content 'Your last urls:'
      [first_url, second_url, third_url].each do |url|
	expect(page).to have_content url.original
	expect(page).to have_css "input##{url.short}"
      end
    end

    scenario '#show' do
      visit valid_url.short
      expect(page).to have_content 'framework'
    end

    scenario '#show with wrong short url' do
      wrong_link = '/itisnotalive'
      visit wrong_link
      expect(page).to have_content 'This link is absent but you can create it'
      expect(page).to have_css 'form'
      value = find('input#url_short').value
      expect(value).to eq wrong_link[1..-1]
    end

    scenario 'clearing session[:absent_link] properly' do
      link = '/stopgoinghere'
      visit link
      visit '/'
      value = find('input#url_short').value
      expect(value).to eq link[1..-1]
      fill_in 'Original url', with: 'https://good/good/place'
      click_button 'Submit'
      value = find('input#url_short').value
      expect(value).to eq ''
      expect(Url.find_by short: link[1..-1]).to_not be_nil
    end
  end
end
