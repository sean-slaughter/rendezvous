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
        if appointment.provider == current_user
            appointment.confirmed = true
            appointment.save
            redirect to "providers/#{current_user.id}"
        else
            redirect to '/failure'
        end
    end

    get '/appointments/:id/deny' do
        check_login
        appointment = Appointment.find(params[:id])
        if appointment.provider == current_user
            appointment.destroy
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
            changed: false,
            cancelled: false

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
        if @appointment.provider == current_user || @appointment.client == current_user
            erb :'appointments/edit'
        else
            redirect to '/failure'
        end
    end

    patch '/appointments/:id' do
        check_login
        appointment = Appointment.find(params[:id])
        change_request = @appointment.provider.appointments << Appointment.create(
            client: @appointment.client
            services: @appointment.services
            date: @appointment.date
            notified: @appointment.notified
            changed: true
            cancelled: false
        )
    end
        

end