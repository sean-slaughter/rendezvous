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

    post '/appointments/:id' do 
        provider = Provider.find(params[:id])
        date = "#{params[:date]} #{params[:time]}"
        provider.appointments.build(

            client: current_user,
            service_ids: params[:service_ids],
            date: DateTime.strptime(date, "%m/%d/%Y %H:%M %p"),
            confirmed: false,
            notified: false

        )
        if provider.save
            redirect to "/providers/#{provider.id}"
        else
            redirect to '/failure'
        end
    end

end