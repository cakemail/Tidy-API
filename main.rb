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

  doc = Nokogiri::HTML(html)

  # Remove the <!-- and --> inside <style> elements.
  # They cause CKEditor to crash.
  doc.xpath('//style').each do |style|
    style.content = style.content.gsub /^[\s\t\n\r]{0,}<!--(.*)-->[\s\t\n\r]{0,}$/m, '\1'
  end

  content_type :json
  data = {:html => doc.to_html}
  data.to_json
end
