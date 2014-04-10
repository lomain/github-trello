require 'sinatra'
require 'json'
require 'trello'

URL_REGEX = /\[?https:\/\/trello.com\/c\/(\w+)\]?:?/

## file = File.open('log/webhooks.log', File::WRONLY | File::APPEND)

Trello.configure do |config|
  file = File.open('log/webhooks.log', 'a')
  file.sync = true
  Trello.logger = Logger.new(file)

  config.consumer_key = 'XXX'
  config.consumer_secret = 'XXX'
  config.oauth_token = 'XXX'
  config.oauth_token_secret = 'XXX'
end


class GithubTrello < Sinatra::Base
  post '/payload' do
    Trello.logger.debug("in '/payload'")
    response = 'no response'
    short_code = ''
    begin
      if params[:payload]
        Trello.logger.debug("has payload:\n#{params[:payload]}")

        push = JSON.parse(params[:payload])

        Trello.logger.debug("parsed github json\n#{push}")

        short_code = trello_short_code(push['head_commit']['message'])
        card = trello_card(short_code) if short_code

        Trello.logger.debug("card: #{card}")

        if short_code && card
          head_commit = push['head_commit']
          author = head_commit['author']['name']
          message = head_commit['message']
          hash = head_commit['id']
          compare_url = push['compare']
          repo = push['repository']['name']
          comment = formatted_comment(repo, author, hash, message, compare_url)
          Trello.logger.debug("About to add comment\n#{comment}")
          card.add_comment(comment)
          response = "Commit: #{comment}"
        else
          response = "No card found"
        end
      else
        status 500
        response = "missing payload"
      end
    rescue Exception => e
      status 500
      response = "Exception with short code: '#{short_code}'\n#{e.to_s}\n#{e.backtrace.join("\n")}\n"
    end

    return response
  end

  def trello_card(code)
    Trello.logger.debug("About to find card #{code}")
    @card ||= Trello::Card.find(code)
  end

  def trello_short_code(commit_message)
    ## result = commit_message.match(%r|https://trello.com/c/(\w+)|)
    result = commit_message.match(URL_REGEX)
    result[1] if result
  end

  def formatted_comment(repo, author_name, hash, message, diff_url)
    <<-EOF.gsub /^ {4}/, ''
      **Commit to #{repo} by #{author_name} [#{hash[0..8]}](#{diff_url})**:

      ```
      #{message.sub!(URL_REGEX, '')}
      ```

    EOF
  end
end


