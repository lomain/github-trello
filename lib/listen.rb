require 'sinatra'
require 'json'
require 'trello'

URL_REGEX = /\[?https:\/\/trello.com\/c\/(\w+)\]?:?/
REFS_REGEX = /^refs\/heads\//

## file = File.open('log/webhooks.log', File::WRONLY | File::APPEND)

Trello.configure do |config|
  file = File.open('log/webhooks.log', 'a')
  file.sync = true
  Trello.logger = Logger.new(file)

  config.consumer_key = 'f1754e0fcf3df99555dd6fee71317ab1'
  config.consumer_secret = 'a7dacf40e522ed3240fab19ae70426386dcb06de220ad3cdf0ea580e0e7ffc28'
  config.oauth_token = 'f9a87675b1bfe04f8ede827c52605eb5fbdad634472cafbefd08c041306a4447'
  config.oauth_token_secret = 'a7dacf40e522ed3240fab19ae70426386dcb06de220ad3cdf0ea580e0e7ffc28'
end


class GithubTrello < Sinatra::Base
  post '/payload' do
    Trello.logger.debug("in '/payload'")
    response = 'no commits'
    short_code = ''
    begin
      if params[:payload]
        push = JSON.parse(params[:payload])

        cards = 0

        branch = push['ref'].gsub(REFS_REGEX, '')
        repo = push['repository']['name']
        allow_master = ('closely-common' == repo) || ('closely-common-scripts' == repo) || ('devops' == repo) || ('Utility-Config' == repo) || ('learning-center' == repo)
        if 'develop' == branch || (allow_master && 'master' == branch)
          push['commits'].each do |commit|
            cards += handle_commit(repo, branch, commit)
          end

          response = "#{cards} cards found"
        end
      else
        status 500
        response = "missing payload"
        Trello.logger.debug ("no payload: #{params}")
      end
    rescue Exception => e
      status 500
      response = "Exception with short code: '#{short_code}'\n#{e.to_s}\n#{e.backtrace.join("\n")}\n"
    end

    return response
  end

  def handle_commit(repo, branch, commit_json)
    Trello.logger.debug("Handling commit\n#{commit_json}")

    short_code = trello_short_code(commit_json['message'])
    card = trello_card(short_code) if short_code

    Trello.logger.debug("card: #{card}")

    count = 0
    if short_code && card
      count = 1
      author = commit_json['author']['name']
      message = commit_json['message']
      hash = commit_json['id']
      compare_url = commit_json['url']
      comment = formatted_comment(repo, branch, author, hash, message, compare_url)
      Trello.logger.debug("About to add comment\n#{comment}")
      card.add_comment(comment)
      response = "Commit: #{comment}"
    else
      response = "No card found"
    end
    
    return count
  end
  
  def trello_card(code)
    Trello.logger.debug("About to find card #{code}")
    Trello::Card.find(code)
  end

  def trello_short_code(commit_message)
    ## result = commit_message.match(%r|https://trello.com/c/(\w+)|)
    result = commit_message.match(URL_REGEX)
    result[1] if result
  end

  def formatted_comment(repo, branch, author_name, hash, message, diff_url)
    <<-EOF.gsub(/^ {4}/, '')
      **Commit to "`#{repo}`:`#{branch}`" by #{author_name} [#{hash[0..8]}](#{diff_url})**:

      ```
      #{message.sub!(URL_REGEX, '')}
      ```

    EOF
  end
end


