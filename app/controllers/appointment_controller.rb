class AppointmentController < ApplicationController

    get '/appointments/:id/new' do
        check_login
        @provider = Provider.find(params[:id])
        if @provider
            erb :'appointments/new'
        else
            redirect to '/failure'
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
            redirect to '/failure'
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
            redirect to '/failure'
        end
    end

    get '/appointments/:id/deny' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            appointment.cancelled = true
            appointment.save
            redirect to "/#{session[:type]}s/#{current_user.id}"
        else
            redirect to '/failure'
        end
    end
    get '/appointments/:id/deny_change' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            appointment.cancelled = true
            appointment.save
        else
            redirect to '/failure'
        end
    end

    post '/appointments/:provider_id' do 
        check_login
        provider = Provider.find(params[:provider_id])
        date = "#{params[:date]} #{params[:time]}"
        provider.appointments.build(

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
            redirect to '/failure'
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
                redirect to '/failure'
            end
        else
            redirect to '/failure'
        end
    end

    get '/appointments/:id/client_cancel' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            appointment.client_cancelled = true
            appointment.save
            redirect to "/#{session[:type]}s/#{current_user.id}"
        else
            redirect to '/failure'
        end
    end

    get '/appointments/:id/provider_cancel' do
        check_login
        appointment = Appointment.find(params[:id])
        if has_permission?(appointment)
            appointment.provider_cancelled = true
            appointment.save
            redirect to "/#{session[:type]}s/#{current_user.id}"
        else
            redirect to '/failure'
        end
    end

    #need to edit for logic about provider/client changing
    patch '/appointments/:id' do
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
                change_request: true,
                cancelled: false,
                cancellation_message: ""
            )
            if appointment.provider.save
                redirect to "/#{session[:type]}s/#{current_user.id}"
            else
                redirect to '/failure'
            end
        else
            redirect to '/failure'
        end
    end

    helpers do
        def has_permission?(appointment)
            appointment.provider == current_user || appointment.client == current_user
        end
    end

        

end