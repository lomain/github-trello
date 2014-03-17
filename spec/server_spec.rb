require 'spec_helper'

describe 'the listener' do
  include Rack::Test::Methods
  
  let(:app) { GithubTrello }
  let(:sample_payload) { File.read('spec/fixtures/push.json') }

  it 'bails with no payload' do
    post '/payload'
    expect(last_response).to be_ok
  end

  it 'bails with bad creds' do
    ENV['TRELLO_KEY'] = '123'
    ENV['TRELLO_MEMBER_TOKEN'] = '123'

    card = double("Trello::Card")
    expect(card).to receive(:add_comment).and_return false
    allow(Trello::Card).to receive(:find).and_return card

    post '/payload', payload: sample_payload
    expect(last_response).to be_ok
  end

  it 'does all the things you expect' do
    card = double("Trello::Card")
    expect(card).to receive(:add_comment).and_return false
    allow(Trello::Card).to receive(:find).and_return card

    post '/payload', payload: sample_payload
    expect(last_response).to be_ok
  end
end

