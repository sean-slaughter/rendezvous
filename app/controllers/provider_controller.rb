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
        if !logged_in?
            redirect to '/login'
        elsif current_user.instance_of?(Provider) && current_user.id == params[:id].to_i
            erb :'providers/profile'
        else
            @provider = Provider.find(params[:id])
            erb :'providers/show'
        end
    end



end