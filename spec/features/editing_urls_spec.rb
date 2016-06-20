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
      expect(page).to have_css "input##{new_url.short}"
      expect(new_url).to_not be_valid
    end

    scenario 'without any changes' do
      click_button 'Submit'
      expect(page).to have_content 'Short link has been updated'
      expect(page).to have_css "input##{url.short}"
      expect(page).to_not have_css "input##{new_url.short}"
      expect(new_url).to be_valid
    end
  end

  context 'unsuccessfully' do

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

    context 'if user is not the author' do
      let(:other_user) { FactoryGirl.create(:user, email: 'alien@example.com') }
      let!(:other_url) { FactoryGirl.create(:url, short: "#{url.short}a", user_id: other_user.id) }

      before do
	click_link 'Sign out'
      end

      scenario 'cannot be reached by anonymous users' do
	[edit_url_path(url), urls_path].each do |path|
	  visit path
	  expect(page).to have_content 'You need to sign in or sign up before continuing'
	end
      end

      scenario 'anonymous user cannot view edit links' do
	make_search_request url.short, 'Short URL'
	within '.list-group' do
	  expect(page).to_not have_link 'Edit'
	end
      end

      scenario 'other user can view only own edit links' do
	login_as(other_user)
	make_search_request url.short, 'Short URL'

	within '.list-group' do
	  expect(page).to have_content url.original
	  expect(page).to have_content other_url.original
	  edit_links = all('.pull-right a').select {|a| a.text == 'Edit' }
	  expect(edit_links.size).to eq 1
	end
      end

      scenario 'cannot be reached by other signed in user' do
	login_as(other_user)
	visit edit_url_path(url)
	expect(page).to have_content 'You are allowed to edit only your own urls'
	expect(page).to have_content 'All your urls'
      end
    end

  end
end
