class ServiceController < ApplicationController

    use Rack::Flash
    
    get '/services/new' do
        if !logged_in?
            redirect to '/login'
        elsif session[:type] == "provider"
            erb :'services/new'
        else
            redirect to '/index'
        end
    end

    post '/services' do
        if !logged_in?
            redirect to '/login'
        elsif session[:type] == "provider"
            current_user.services << Service.create(
                name: params[:name], 
                price: params[:price].remove("$").to_d, 
                description: params[:description] 
            )
            flash.now[:notification] = "Your service has been created."
            redirect to "/providers/#{current_user.id}/edit"
        else
            flash.now[:error] = "You do not have permission to do that."
            redirect to '/index'
        end
    end

    get '/services/:id/edit' do
        @service = Service.find(params[:id])
        if !logged_in?
            redirect to '/login'
        elsif has_permission?(@service)
            erb :'services/edit'
        else
            redirect to '/index'
        end
    end

    patch '/services/:id' do
        @service = Service.find(params[:id])
        if !logged_in?
            redirect to '/login'
        elsif has_permission?(@service)
            @service.name = params[:name]
            @service.description = params[:description]
            @service.price = params[:price].remove("$").to_d
            if @service.save
                flash.now[:notification] = "Your service #{@service.name} has been updated."
                redirect to "/providers/#{current_user.id}/edit"
            else
                flash.now[:error] = @service.errors.full_messages[0]
                :'services/edit'
            end
        else
            flash.now[:error] = "Something went wrong."
            redirect to '/index'
        end
    end

    delete '/services/:id' do
        if !logged_in?
            redirect to '/login'
        else
            @service = Service.find(params[:id])
            if has_permission?(@service)
                @service.destroy
                flash.now[:notification] = "Your service: #{@service.name} has been deleted."
            end
            redirect to "/providers/#{current_user.id}/edit"
        end
    end


    helpers do
        def has_permission?(service)
            current_user.instance_of?(Provider) && current_user.services.include?(service)
        end
    end

end