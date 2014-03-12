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

## Development

It's a little Sinatra app.

1. `git clone https://github.com/gaslight/github-trello.git`
1. `bundle install`

### Testing

1. `rspec spec`

## License

MIT

