class ClientController < ApplicationController


    get '/clients/signup' do
        erb :'clients/new'
    end

    post '/clients' do

    end

    get '/clients/:id' do 
        erb :'clients/profile'
    end


end