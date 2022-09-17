class HomeController < ApplicationController
require "uri"
require "net/http"
  def index
  end
  def about
  end

  def prova_git

  end
  
  def sign_in
    
    url = URI("https://github.com/login/oauth/authorize?client_id=c14b97d28ab63f7ea177&redirect_uri=http://localhost:3000")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    puts response.read_body
  end

end
