require 'rspec'
require 'rspec/mocks'
require 'rack/test'

ENV['RACK_TEST'] = 'test'
ENV['TRELLO_KEY'] = '123'
ENV['TRELLO_MEMBER_TOKEN'] = '123'

require 'listen'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end


