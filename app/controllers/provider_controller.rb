class ProviderController < ApplicationController

    get '/providers/signup' do
        if !logged_in?
            erb :'providers/new'
         else
            redirect to "/#{session[:type]}s/#{current_user.id}"
         end
    end

    get '/providers' do
        @providers = Provider.all
        erb :'/providers/index'
    end

    post '/providers/search' do
        @providers = Provider.search(params[:q])
        if @providers.empty?
            @providers = Service.search(params[:q])
        else
            Service.search(params[:q]).each{|provider| @providers << provider} unless Service.search(params[:p]).empty?
        end
        @providers = @providers.uniq
    
        erb :'/providers/index'
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
       check_login
       if has_permission?
            get_changes
            erb :'providers/profile'
        else
            @provider = Provider.find(params[:id])
            
            erb :'providers/show'
        end
    end

    get '/providers/:id/edit' do
        check_login
        if has_permission?
            erb :'providers/edit'
        else
            redirect to '/failure'
        end
    end

    patch '/providers/:id' do
       check_login
       if has_permission?
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
        check_login
        if has_permission?
            current_user.destroy
            redirect to '/logout'
        end
    end

    helpers do
        def has_permission?
            current_user.instance_of?(Provider) && current_user.id == params[:id].to_i
        end

        def get_changes
            @confirmed_appointments = []
            @unconfirmed_appointments = []
            @unconfirmed_changes = []
            @new_cancellations = []
            @new_change_denials = []
            @new_change_confirmations = []
            @unconfirmed_changes = current_user.unconfirmed_changes if current_user.unconfirmed_changes
            @confirmed_appointments = current_user.confirmed_appointments if current_user.confirmed_appointments
            @unconfirmed_appointments = current_user.unconfirmed_appointments if current_user.unconfirmed_appointments
            @new_change_denials = current_user.new_change_denials if current_user.new_change_denials
            @new_change_confirmations = current_user.new_change_confirmations if current_user.new_change_confirmations
            @new_cancellations = current_user.new_cancellations if current_user.new_cancellations
        end
    end

end