require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :index
  end

  get "/login" do

  end

  get '/logout' do 

  end

  helpers do

    def login
    end

    def logout
    end

    def logged_in?
    end

    def current_user
    end
    
  end
end
