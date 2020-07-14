class ClientController < ApplicationController


    get '/clients/signup' do
        erb :'clients/new'
    end

    post '/clients' do
        client = Client.new(params)
        if client.save
            login(client.email, client.password)
            redirect to "/clients/#{client.id}"
        else
            redirect to '/clients/signup'
        end
    end

    get '/clients/:id' do
        erb :'clients/profile'
    end


end