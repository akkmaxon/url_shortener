module MyHelpers
  def make_search_request(keywords, direction)
    fill_in :search_keywords, with: keywords
    click_button 'search_menu'
    click_button direction
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = [:expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.default_formatter = 'doc'

  config.include MyHelpers
end
