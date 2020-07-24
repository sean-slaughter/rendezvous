class ServiceController < ApplicationController

    use Rack::Flash
    
    #new service form
    #only show if current user is a provider
    get '/services/new' do
        if !logged_in?
            redirect to '/login'
        elsif session[:type] == "provider"
            erb :'services/new'
        else
            redirect to '/index'
        end
    end

    #create a new service
    #postcondition: new service object has been created and associated with current user
    post '/services' do
        if !logged_in?
            redirect to '/login'
        elsif session[:type] == "provider"
            current_user.services << Service.create(
                name: params[:name], 
                price: params[:price].remove("$").to_d, 
                description: params[:description] 
            )
            flash.now[:notification] = "Your service '#{current_user.services.last.name}' has been created."
            erb :'providers/edit'
        else
            flash.now[:error] = "You do not have permission to do that."
            redirect to '/index'
        end
    end

    #edit service
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

    #edit service
    #postcondition: service information is updated and saved
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
            flash[:error] = "Something went wrong."
            redirect to '/index'
        end
    end

    #delete service
    delete '/services/:id' do
        if !logged_in?
            redirect to '/login'
        else
            @service = Service.find(params[:id])
            if has_permission?(@service)
                @service.destroy
                flash.now[:error] = "Your service: #{@service.name} has been deleted."
                erb :'providers/edit'
            else
                flash[:error] = "You don't have permission to do that."
                redirect to '/index'
            end
        end
    end


    helpers do

        #is the current user the provider of this service?
        def has_permission?(service)
            current_user.instance_of?(Provider) && current_user.services.include?(service)
        end
    end

end