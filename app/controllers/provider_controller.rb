class ProviderController < ApplicationController

    use Rack::Flash

    #new provider signup
    get '/providers/signup' do
        if !logged_in?
            erb :'providers/new'
         else
            redirect to "/#{session[:type]}s/#{current_user.id}"
         end
    end
    
    #provider index page
    get '/providers' do
        check_login
        @providers = Provider.all
        erb :'/providers/index'
    end

    #display provider search results
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

    #create new provider
    #postcondition: new provider object created from user input and logged in as current_user    
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

    #display provider profile page if logged in, else provider show page
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

    #edit provider page
    get '/providers/:id/edit' do
        check_login
        if has_permission?
            erb :'providers/edit'
        else
            flash.now[:error] = "Something went wrong."
            redirect to '/index'
        end
    end

    #edit provider page
    #postcondition: provider profile has been updated with user input and saved
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
    
    #delete current_user
    #postcondition: current_user is destroyed and session data is cleared.
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
        #is the current user a provider and the right id?
        def has_permission?
            current_user.instance_of?(Provider) && current_user.id == params[:id].to_i
        end

        #uses model instance methods to determine current state of all appointments
        #postcondition: new confirmations, denials, requests, and cancellations are all
        #loaded into arrays for displaying on the page.    
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