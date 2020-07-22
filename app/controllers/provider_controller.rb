class ProviderController < ApplicationController

    use Rack::Flash

    get '/providers/signup' do
        if !logged_in?
            erb :'providers/new'
         else
            redirect to "/#{session[:type]}s/#{current_user.id}"
         end
    end

    get '/providers' do
        check_login
        @providers = Provider.all
        erb :'/providers/index'
    end

    post '/providers/search' do
        check_login
        @providers = Provider.search(params[:q])
        if @providers.empty?
            @providers = Service.search(params[:q])
        else
            Service.search(params[:q]).each{|provider| @providers << provider} unless Service.search(params[:p]).empty?
        end
        
        @providers = @providers.uniq.compact
        erb :'/providers/index'
    end

    post '/providers' do
        params[:email] = params[:email].downcase
        if Client.get_emails.include?(params[:email])
            flash.now[:error] = "Email is already taken."
            erb :'/providers/new'
        else
            provider = Provider.new(params)
            if provider.save
                login(provider.email, provider.password)
                redirect to "/providers/#{provider.id}"
            else
                flash.now[:error] = provider.errors.full_messages[0]
                erb :'providers/new'
            end
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
            flash.now[:error] = "Something went wrong."
            redirect to '/index'
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
                flash.now[:notification] = "Your account information has been updated."
                get_changes
                erb :'providers/profile'
            else
                flash.now[:error] = "Something went wrong."
                redirect to '/index'
            end
        else
            redirect to "/providers/#{params[:id]}"
        end
    end
    
    delete '/providers/:id' do
        check_login
        if has_permission?
            current_user.destroy
            session.clear
            flash.now[:error] = "Your account has been deleted."
            erb :'index'
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