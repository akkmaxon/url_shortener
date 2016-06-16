require 'rails_helper'

RSpec.feature 'Search urls' do
  def make_search_request(keywords, direction)
    fill_in :search_keywords, with: keywords
    click_button 'search_menu'
    click_button direction
  end

  let!(:first) { FactoryGirl.create(:url, original: 'http://first/original/link',
					  short: 'firstshort',
					  description: 'Describe first link') }
  let!(:second) { FactoryGirl.create(:url, original: 'http://second/original/link',
					   short: 'secondshort',
					   description: 'Describe second link') }
  let!(:third) { FactoryGirl.create(:url, original: 'http://third/original/link',
					  short: 'thirdshort',
					  description: 'Unique description for third') }
  before do
    visit '/'
  end

  scenario 'page show found links properly' do
    make_search_request 'original', 'Original URL'
    [first, second, third].each do |link|
      expect(page).to have_content link.original
      expect(page).to have_content link.short
      expect(page).to have_content link.description
    end
  end

  scenario 'with empty values' do
    make_search_request '', 'Short URL'
    expect(page).to have_content 'Your search request is empty'
    expect(page).to_not have_content first.original
    expect(page).to_not have_content second.original
    expect(page).to_not have_content third.original
  end

  context 'single words' do
    scenario 'entering original url' do
      make_search_request 'first', 'Original URL'
      expect(page).to have_content first.original
      expect(page).to_not have_content second.original
      expect(page).to_not have_content third.original
    end

    scenario 'entering short url' do
      make_search_request 'secondshort', 'Short URL'
      expect(page).to_not have_content first.original
      expect(page).to have_content second.original
      expect(page).to_not have_content third.original
    end
  end

  context 'several words' do
    scenario 'entering original url' do
      make_search_request 'first third', 'Original URL'
      expect(page).to have_content first.original
      expect(page).to_not have_content second.original
      expect(page).to have_content third.original
    end

    scenario 'entering short url' do
      make_search_request 'first second', 'Short URL'
      expect(page).to have_content first.original
      expect(page).to have_content second.original
      expect(page).to_not have_content third.original
    end

    scenario 'entering unique description' do
      make_search_request 'Unique description for third', 'Description'
      expect(page).to_not have_content first.original
      expect(page).to_not have_content second.original
      expect(page).to have_content third.original
    end

    scenario 'entering random description' do
      make_search_request 'Describe third link', 'Description'
      expect(page).to have_content first.original
      expect(page).to have_content second.original
      expect(page).to have_content third.original
    end
  end
end
