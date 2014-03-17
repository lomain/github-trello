require 'spec_helper'

describe 'generating markdown comments' do
  let(:author) { 'cdmwebs' }
  let(:message) { "Merge branch 'master' into develop\n\nhttps://trello.com/c/0jTMFm2d" }
  let(:url) { "https://github.com/lumbee/Lumbeeapps/compare/ebad9a15257b...27d87238baf0" } 
  subject { CommentFormatter.new }
  let(:comment) { subject.formatted_comment(author, message, url) } 

  it 'creates a useful comment' do
    expect(comment).to match /cdmwebs/
    expect(comment).to match /Merge branch/
    expect(comment).to match /ebad9a15257b/
  end
end
