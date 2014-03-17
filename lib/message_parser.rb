class MessageParser
  def self.trello_short_code(commit_message)
    result = commit_message.match(%r|https://trello.com/c/(.*)|)
    result[1] if result
  end
end

