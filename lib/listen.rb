require 'sinatra'
require 'json'
require 'trello'
require 'comment_formatter'

Trello.configure do |config|
  config.developer_public_key = ENV.fetch('TRELLO_KEY')
  config.member_token = ENV.fetch('TRELLO_MEMBER_TOKEN')
end

class GithubTrello < Sinatra::Base
  post '/payload' do
    if params[:payload]
      push = JSON.parse(params[:payload])

      short_code = trello_short_code(push['head_commit']['message'])
      card = trello_card(short_code) if short_code

      if short_code && card
        author = push['head_commit']['author']['name']
        message = push['head_commit']['message']
        compare_url = push['compare']
        comment = formatted_comment(author, message, compare_url)
        card.add_comment(comment)
      end
    end
  end
end

