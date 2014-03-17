require 'spec_helper'

describe MessageParser do
  let(:short_code) { MessageParser.trello_short_code(message) }

  context 'with a known good message' do
    let(:message) do
      "Merge branch 'master' into develop\n\n* master:\n  Don't try to submit invoices unless they're ready\n  Process invoices in the background\n\nhttps://trello.com/c/0jTMFm2d"
    end

    it 'parses the shortcode from the trello url if present' do
      expect(short_code).to eq('0jTMFm2d')
    end

    it 'removes the shortcode line from the message'
  end

  context 'with a known bad message' do
    let(:message) { "Merge branch 'master' into develop" }

    it 'parses the shortcode from the trello url if present' do
      expect(short_code).to be_nil
    end
  end
end

