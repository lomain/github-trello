require 'trello'

class CommentFormatter
  def trello_card(code)
    @card ||= Trello::Card.find(code)
  end

  def trello_short_code(commit_message)
    result = commit_message.match(%r|https://trello.com/c/(.*)|)
    result[1] if result
  end

  def formatted_comment(author_name, message, diff_url)
    <<-EOF.gsub /^ {4}/, ''
      **Commit by #{author_name}**:

      ```
      #{message}
      ```

      [View Commit](#{diff_url})
    EOF
  end
end


