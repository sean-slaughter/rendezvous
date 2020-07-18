class ProviderController < ApplicationController

    get '/providers/signup' do
        erb :'providers/new'
    end

    post '/providers' do
        params[:email] = params[:email].downcase
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
        elsif has_permission?
            @unconfirmed_appointments = []
            @changed_appointments = []
            @cancelled_appointments = []
            if current_user.unconfirmed_appointments
                @unconfirmed_appointments = current_user.unconfirmed_appointments
            end
            if current_user.changed_appointments
                @changed_appointments = current_user.changed_appointments
            end
            if current_user.cancelled_appointments
                @cancelled_appointments = current_user.cancelled_appointments
            end
            erb :'providers/profile'
        else
            @provider = Provider.find(params[:id])
            
            erb :'providers/show'
        end
    end

    get '/providers/:id/edit' do
        if !logged_in?
            redirect to '/login'
        elsif has_permission?
            erb :'providers/edit'
        else
            redirect to '/failure'
        end
    end

    patch '/providers/:id' do
        if !logged_in?
            redirect to '/login'
        elsif has_permission?
            current_user.business_name = params[:business_name]
            current_user.name = params[:name]
            current_user.email = params[:email]
            current_user.phone_number = params[:phone_number]
            current_user.location = params[:location]
            if current_user.save
                redirect to "/providers/#{params[:id]}"
            else
                redirect to '/failure'
            end
        else
            redirect to "/providers/#{params[:id]}"
        end
    end
    
    delete '/providers/:id' do
        if !logged_in?
            redirect to '/login'
        elsif has_permission?
            current_user.destroy
            redirect to '/logout'
        end
    end

    helpers do
        def has_permission?
            current_user.instance_of?(Provider) && current_user.id == params[:id].to_i
        end
    end

end