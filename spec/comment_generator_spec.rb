require 'spec_helper'

describe CommentFormatter do
  let(:author) { 'cdmwebs' }
  let(:message) { "Merge branch 'master' into develop\n\nhttps://trello.com/c/0jTMFm2d" }
  let(:url) { "https://github.com/lumbee/Lumbeeapps/compare/ebad9a15257b...27d87238baf0" } 
  let(:comment) { subject.formatted_comment(author, message, url) } 

  it 'creates a useful comment' do
    expect(comment).to match /cdmwebs/
    expect(comment).to match /Merge branch/
    expect(comment).to match /ebad9a15257b/
  end

  it 'removes leading whitespace' do
    expect(comment).to match /^\*\*Commit by/
  end
end
