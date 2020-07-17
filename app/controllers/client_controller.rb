class ClientController < ApplicationController


    get '/clients/signup' do
        erb :'clients/new'
    end

    post '/clients' do
        params[:email] = params[:email].downcase
        client = Client.new(params)
        if client.save
            login(client.email, client.password)
            redirect to "/clients/#{client.id}"
        else
            redirect to '/clients/signup'
        end
    end

    get '/clients/:id' do
        check_login
        if has_permission?
            if current_user.new_confirmations
                @new_confirmations = current_user.new_confirmations
            end
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
            redirect to '/failure'
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
                redirect to '/failure'
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
    end


end