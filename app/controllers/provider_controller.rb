class ProviderController < ApplicationController

    get '/providers/signup' do
        erb :'providers/new'
    end

    post '/providers' do
        provider = Provider.new(params)
        if provider.save
            login(provider.email, provider.password)
            redirect to "/providers/#{provider.id}"
        else
            redirect to '/providers/signup'
        end
    end

    get '/providers/:id' do 
        erb :'providers/profile'
    end



end