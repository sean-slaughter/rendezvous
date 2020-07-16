require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "mS@IMD@<2)D<M!@)I1Q(U!@9"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :index
  end

  get '/failure' do
    erb :failure
  end

  get '/login' do
       erb :login
  end

  post '/login' do
    login(params[:email], params[:password])
  end

  get '/logout' do 
    session.clear
    redirect to '/'
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def login(email, password)
      user = Client.find_by(email: email)
      if user
        if user.authenticate(password)
          session[:user_id] = user.id
          session[:type] = "client"
          redirect to "/clients/#{user.id}"
        else
          redirect to '/failure'
        end
      else
        user = Provider.find_by(email: email)
        if user
          if user.authenticate(password)
            session[:user_id] = user.id
            session[:type] = "provider"
            redirect to "/providers/#{user.id}"
          else
            redirect to '/failure'
          end
        else
          redirect to '/failure'
        end
      end
    end


    def current_user
       if session[:type] == "client"
        @current_user ||= Client.find(session[:user_id]) if session[:user_id]
       elsif session[:type] == "provider"
        @current_user ||= Provider.find(session[:user_id]) if session[:user_id]
       end
    end

    def logout
      session.clear
    end
    
  end
end
