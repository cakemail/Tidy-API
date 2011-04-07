require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'json'

configure :production do
  set :port, 80
end

get '/clean' do
<<-eos
  <form method="POST">
  <textarea name="html"></textarea>
  <button>Submit</button>
  </form>
eos
end

post '/clean' do
  error 400 if !params[:html]

  html = params[:html]

  cleaned_html = Nokogiri::HTML(html).to_html

  content_type :json
  data = {:html => cleaned_html}
  data.to_json
end
