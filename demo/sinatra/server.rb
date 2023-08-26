require 'bundler/setup'
require 'dotenv/load'
require 'sinatra'
require 'smartcaptcha'

Smartcaptcha.configure do |config|
  config.client_key = ENV['CLIENT_KEY']
  config.server_key = ENV['SERVER_KEY']
end

include Smartcaptcha::Adapters::ControllerMethods
include Smartcaptcha::Adapters::ViewMethods

get '/' do
  <<-HTML
    <form action="/verify">
      #{smartcaptcha_tags()}
      <input type="submit"/>
    </form>
  HTML
end

get '/verify' do
  if verify_smartcaptcha
    'YES!'
  else
    'NO!'
  end
end
