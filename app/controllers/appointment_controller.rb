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

    post '/appointments/:id' do 
        provider = Provider.find(params[:id])
        date = "#{params[:date]} #{params[:time]}"
        provider.appointments.build(

            client: current_user,
            service_ids: params[:service_ids],
            date: DateTime.strptime(date, "%m/%d/%Y %H:%M %p")

        )
        if provider.save
            redirect to "/providers/#{provider.id}"
        else
            redirect to '/failure'
        end
    end

end