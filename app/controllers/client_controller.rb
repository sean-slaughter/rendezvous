class ClientController < ApplicationController

use Rack::Flash

    get '/clients/signup' do
        if !logged_in?
            erb :'clients/new'
         else
           redirect to "/#{session[:type]}s/#{current_user.id}"
         end
    end

    post '/clients' do
        params[:email] = params[:email].downcase
        if Provider.get_emails.include?(params[:email])
            flash.now[:error] = "Email has already been taken."
            erb :'clients/new'
        else
            client = Client.new(params)
            if client.save
                login(client.email, client.password)
                redirect to "/clients/#{client.id}"
            else
                flash.now[:error] = client.errors.full_messages[0]
                erb :'clients/new'
            end
        end
    end

    get '/clients/:id' do
        check_login
        if has_permission?
            get_changes
            erb :'clients/profile'
        else
            @client = Client.find(params[:id])
            erb :'clients/show'
        end 
    end

    get '/clients/:id/edit' do
        check_login
        if has_permission?
            erb :'clients/edit'
        else
            redirect to '/index'
        end
    end
            

    patch '/clients/:id' do
        check_login
        if has_permission?
            current_user.name = params[:name]
            current_user.email = params[:email]
            current_user.phone_number = params[:phone_number]
            current_user.location = params[:location]
            if current_user.save
                redirect to "/clients/#{params[:id]}"
            else
                redirect to '/index'
            end
        else
            redirect to "/clients/#{params[:id]}"
        end
    end

    delete '/clients/:id' do
        check_login
        if has_permission?
            current_user.destroy
            redirect to '/logout'
        end
    end

    helpers do
        def has_permission?
            current_user.instance_of?(Client) && current_user.id == params[:id].to_i
        end

        def get_changes
            @new_confirmations = []
            @new_denials = []
            @new_change_confirmations = []
            @new_change_denials = []
            @unconfirmed_changes = []
            @new_cancellations = []
            @confirmed_appointments = []
            @unconfirmed_changes = current_user.unconfirmed_changes if current_user.unconfirmed_changes
            @confirmed_appointments = current_user.confirmed_appointments if current_user.confirmed_appointments
            @new_cancellations = current_user.new_cancellations if current_user.new_cancellations
            @new_change_denials = current_user.new_change_denials if current_user.new_change_denials
            @new_denials = current_user.new_denials if current_user.new_denials
            @new_confirmations = current_user.new_confirmations if current_user.new_confirmations
            @new_change_confirmations = current_user.new_change_confirmations if current_user.new_change_confirmations
            @new_change_denials = current_user.new_change_denials if current_user.new_change_denials
        end
    end


end