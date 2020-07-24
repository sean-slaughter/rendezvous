class AppointmentController < ApplicationController

use Rack::Flash

    #new appointment get request
    get '/appointments/:id/new' do
        check_login
        @provider = Provider.find(params[:id])
        if @provider
            erb :'appointments/new'
        else
            flash[:error] = "Something went wrong."
            redirect to '/index'
        end
    end

    #new appointment confirmation get request
    #postcondition: appointment has been confirmed
    get '/appointments/:id/confirm' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            appointment.confirmed = true
            appointment.save
            redirect to "providers/#{current_user.id}"
        else
            flash[:error] = "Something went wrong."
            redirect to '/index'
        end
    end

    #new appointment change get request
    #postcondition: appointment change has been confirmed
    get '/appointments/:id/confirm_change' do
        check_login
        new_appointment = Appointment.find(params[:id])
        old_appointment = current_user.get_old_appointment(new_appointment)
        if has_permission?(new_appointment)
            new_appointment.confirmed = true
            new_appointment.save
            old_appointment.destroy
            redirect to "/#{session[:type]}s/#{current_user.id}"
        else
            redirect to '/index'
        end
    end
    
    #appointment denial get request
    #postcondition appointment cancellation and notification status are true
    get '/appointments/:id/deny' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            if session[:type] == "client"
                appointment.client_cancelled = true
                appointment.notified = true
                appointment.save
                redirect to "/#{session[:type]}s/#{current_user.id}"
            elsif session[:type] == "provider"
                appointment.provider_cancelled = true
                appointment.notified = true
                appointment.save
                redirect to "/#{session[:type]}s/#{current_user.id}"
            else
                flash.now[:error] = "Something went wrong."
                redirect to '/index'
            end
        else
            redirect to '/index'
        end
    end

    #creating a new appointment with a provider
    #postcondition: new appointment object has been created from user input
    post '/appointments/:provider_id' do 
        check_login
        @provider = Provider.find(params[:provider_id])
        date = "#{params[:date]} #{params[:time]}"
        @provider.appointments.build(
            client: current_user,
            service_ids: params[:service_ids],
            date: DateTime.strptime(date, "%m/%d/%Y %H:%M %p"),
            confirmed: false,
            notified: false,
            client_request_change: false,
            client_cancelled: false,
            provider_request_change: false,
            provider_cancelled: false,
            cancellation_message: ""
        )
        if @provider.save
            flash[:notification] = "Your appointment at #{@provider.business_name} has been requested."
            redirect to "/clients/#{current_user.id}"
        else
            flash.now[:error] = @provider.errors.full_messages[0]
            erb :'appointments/new'
        end
    end

    #editing an appointment get request
    #sends user to either client or provider edit page based on their type
    get '/appointments/:id/edit' do
        check_login
        @appointment = Appointment.find(params[:id])
        if has_permission?(@appointment)
            if session[:type] == "client"
                erb :'appointments/client_edit'
            elsif session[:type] == "provider"
                erb :'appointments/provider_edit'
            else
                flash.now[:error] = "Something went wrong."
                redirect to '/index'
            end
        else
            flash.now[:error] = "You do not have permission to do that."
            redirect to '/index'
        end
    end

    #client appointment cancellation    
    #postcondition: client_cancelled = true
    patch '/appointments/:id/client_cancel' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            appointment.client_cancelled = true
            appointment.cancellation_message = params[:cancellation_message]
            appointment.save
            flash[:notification] = "Your appointment has been cancelled."
            redirect to "/#{session[:type]}s/#{current_user.id}"
        else
            flash.now[:error] = "You do not have permission to do that."
            redirect to '/index'
        end
    end

    #provider appointment cancellation
    #postcondition: provider_cancelled = true
    patch '/appointments/:id/provider_cancel' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            appointment.provider_cancelled = true
            appointment.cancellation_message = params[:cancellation_message]
            appointment.save
            redirect to "/#{session[:type]}s/#{current_user.id}"
        else
            flash.now[:error] = "You do not have permission to do that."
            redirect to '/index'
        end
    end

    #client request to change appointment
    #postcondition: new appointment has been created, old appointment is associated with it
    #will not be destroyed until other party has been asked to confirm/deny
    patch '/appointments/:id/client_change' do
        check_login
        appointment = Appointment.find(params[:id])
        date = "#{params[:date]} #{params[:time]}"
        if has_permission?(appointment)
            appointment.provider.appointments.build(
                client: appointment.client,
                service_ids: params[:service_ids],
                date: DateTime.strptime(date, "%m/%d/%Y %H:%M %p"),
                notified: false,
                confirmed: false,
                client_request_change: true,
                provider_request_change: false,
                client_cancelled: false,
                provider_cancelled: false,
                cancellation_message: "",
                old_appointment: appointment.id
            )
            if appointment.provider.save

                redirect to "/#{session[:type]}s/#{current_user.id}"
            else
                flash.now[:error] = "Something went wrong."
                redirect to '/index'
            end
        else
            flash.now[:error]= "You do not have permission to do that."
            redirect to '/index'
        end
    end

    #provider request to change appointment
    #postcondition: new appointment has been created, old appointment is associated with it
    #will not be destroyed until other party has been asked to confirm/deny
    patch '/appointments/:id/provider_change' do
        check_login
        appointment = Appointment.find(params[:id])
        date = "#{params[:date]} #{params[:time]}"
        if has_permission?(appointment)
                appointment.client.appointments.build(
                confirmed: false,
                provider: appointment.provider,
                services: appointment.services,
                date: DateTime.strptime(date, "%m/%d/%Y %H:%M %p"),
                notified: false,
                client_request_change: false,
                provider_request_change: true,
                client_cancelled: false,
                provider_cancelled: false,
                cancellation_message: "",
                old_appointment: appointment.id
            )
            if appointment.client.save
                flash[:notification] = 
                redirect to "/#{session[:type]}s/#{current_user.id}"
            else
                flash[:error] = "Something went wrong."
                redirect to '/index'
            end
        else
            flash[:error] = "You do not have permission to do that."
            redirect to '/index'
        end
    end

    #does current user have anything to do with this appointment?
    helpers do
        def has_permission?(appointment)
            appointment.provider == current_user || appointment.client == current_user
        end
    end

        

end