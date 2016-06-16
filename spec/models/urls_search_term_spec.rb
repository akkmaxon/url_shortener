require 'rails_helper'

RSpec.describe UrlsSearchTerm do
  let(:keywords) { 'something, anything , ' }

  it '#search_original_url' do
    urls_search_term = UrlsSearchTerm.new(keywords, 'Original URL')
    expect(urls_search_term.where_clause).to eq(
      'original ilike :something OR original ilike :anything')
    expect(urls_search_term.where_args.size).to eq 2
    expect(urls_search_term.where_args[:something]).to eq '%something%'
    expect(urls_search_term.where_args[:anything]).to eq '%anything%'
    expect(urls_search_term.order).to eq 'updated_at desc'
  end

  it '#search_short_url' do
    urls_search_term = UrlsSearchTerm.new(keywords, 'Short URL')
    expect(urls_search_term.where_clause).to eq(
      'short ilike :something OR short ilike :anything')
    expect(urls_search_term.where_args.size).to eq 2
    expect(urls_search_term.where_args[:something]).to eq '%something%'
    expect(urls_search_term.where_args[:anything]).to eq '%anything%'
    expect(urls_search_term.order).to eq 'updated_at desc'
  end

  it '#search_description_url' do
    urls_search_term = UrlsSearchTerm.new(keywords, 'Description')
    expect(urls_search_term.where_clause).to eq(
      'description ilike :anything OR description ilike :something OR description ilike :somethinganything')
    expect(urls_search_term.where_args.size).to eq 3
    expect(urls_search_term.where_args[:something]).to eq '%something%'
    expect(urls_search_term.where_args[:anything]).to eq '%anything%'
    expect(urls_search_term.where_args[:somethinganything]).to eq "%#{keywords}%"
  end
end
