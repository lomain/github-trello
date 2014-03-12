$:.unshift(File.expand_path('../lib', __FILE__))
require 'rubygems'
require 'bundler'

Bundler.require

require 'listen'
run GithubTrello

