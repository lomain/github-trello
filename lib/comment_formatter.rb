require 'trello'

class CommentFormatter
  def formatted_comment(author_name, message, diff_url)
    <<-EOF.gsub /^ {6}/, ''
      **Commit by #{author_name}**:

      ```
      #{message}
      ```

      [View Commit](#{diff_url})
    EOF
  end
end

