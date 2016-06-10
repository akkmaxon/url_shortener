require 'rails_helper'

RSpec.describe Url do
  
  context 'create url' do
    it 'create url with all properties' do
      url = FactoryGirl.build(:url)
      expect(url).to be_valid
    end

    it 'create url without description' do
      url = FactoryGirl.build(:url, description: '')
      expect(url).to be_valid
    end
  end

  context "don't create url" do
    it 'with original property only' do
      url = FactoryGirl.build(:url, short: '', description: '')
      expect(url).to_not be_valid
    end

    it 'with short property only' do
      url = FactoryGirl.build(:url, original: '', description: '')
      expect(url).to_not be_valid
    end 

    it 'with description only' do
      url = FactoryGirl.build(:url, original: '', short: '')
      expect(url).to_not be_valid
    end
  end

  context 'manage urls by user' do
    let(:user) { FactoryGirl.build(:user) }
    before do
      @url = user.urls.build original: 'http://somewhere.com',
	short: 'http://s.com', description: 'Description'
    end

    it 'build urls' do
      expect(@url).to be_valid
    end
  end
end
