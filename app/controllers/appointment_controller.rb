class AppointmentController < ApplicationController

use Rack::Flash

    get '/appointments/:id/new' do
        check_login
        @provider = Provider.find(params[:id])
        if @provider
            erb :'appointments/new'
        else
            flash.now[:error] = "Something went wrong."
            redirect to '/index'
        end
    end

    get '/appointments/:id/confirm' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            appointment.confirmed = true
            appointment.save
            redirect to "providers/#{current_user.id}"
        else
            flash.now[:error] = "Something went wrong."
            redirect to '/index'
        end
    end

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
        if provider.save
            redirect to "/providers/#{provider.id}"
        else
            flash.now[:error] = @provider.errors.full_messages[0]
            erb :'appointments/new'
        end
    end

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

    patch '/appointments/:id/client_cancel' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            appointment.client_cancelled = true
            appointment.cancellation_message = params[:cancellation_message]
            appointment.save
            redirect to "/#{session[:type]}s/#{current_user.id}"
        else
            flash.now[:error] = "You do not have permission to do that."
            redirect to '/index'
        end
    end

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

    #need to edit for logic about provider/client changing
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
                cancellation_message: ""
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

    patch '/appointments/:id/provider_change' do
        check_login
        appointment = Appointment.find(params[:id])
        date = "#{params[:date]} #{params[:time]}"
        if has_permission?(appointment)
            test = appointment.client.appointments.build(
                confirmed: false,
                provider: appointment.provider,
                services: appointment.services,
                date: DateTime.strptime(date, "%m/%d/%Y %H:%M %p"),
                notified: false,
                client_request_change: false,
                provider_request_change: true,
                client_cancelled: false,
                provider_cancelled: false,
                cancellation_message: ""
            )
            if appointment.client.save
                redirect to "/#{session[:type]}s/#{current_user.id}"
            else
                flash.now[:error] = "Something went wrong."
                redirect to '/index'
            end
        else
            flash.now[:error] = "You do not have permission to do that."
            redirect to '/index'
        end
    end

    helpers do
        def has_permission?(appointment)
            appointment.provider == current_user || appointment.client == current_user
        end
    end

        

end