# GitHub commits to Trello comments

Does what it says on the tin. Push GitHub commits to Trello comments
with some details.

## Setup

1. Add a webhook to your repo:
  1. Go to Settings for the repo.
  1. Click Webhooks & Services.
  1. Click Add Webhook
  1. Paste http://gaslight-github-trello.herokuapp.com/payload
  1. Save and profit!!!
1. Make sure your Trello user (Wendell in our case) has access to the
   board.

## Using It

1. Write an [awesome commit
   message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).
1. Stick the short URL of the card at the bottom of the message thusly:

   ```
   This is the subject.

   Here is a longer description of what I actually did. It could be an
   entire paragraph.

   * It could also include bullet points.
   * Like these.

   https://trello.com/c/shortcode
   ```
1. Watch as your comments magically appear.
   ![screenshot](http://cl.ly/UOKR/Screen%20Shot%202014-03-12%20at%2012.16.51%20PM.png)

## Development

It's a little Sinatra app.

1. `git clone https://github.com/gaslight/github-trello.git`
1. `bundle install`

### Testing

1. `rspec spec`

## License

[MIT](LICENSE.md)

