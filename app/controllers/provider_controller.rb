class ProviderController < ApplicationController

    get '/providers/signup' do
        erb :'providers/new'
    end

    post '/providers' do

    end

    get '/providers/:id' do 
        erb :'providers/profile'
    end

    

end