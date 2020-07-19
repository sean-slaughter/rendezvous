TODO For 7/14:

- Registration and Login


TODO for 7.15:

- Client and Provider profile pages
- Confirm no registration bugs
- Validation of single email addresses

end of day 7.15:
- Edit Provider Profile
- Add services
- Clients can request appointments
- Provider confirms appointments
- Client cannot see appointment until confirmed
- Provider and client can cancel appointment
- Client notified on appointment confirmation
- Provider and client notified on appointment cancellation


TODO for 7.16
Validation of single email address
Edit Provider Profile
Add Services
Start working on appointments if time

end of day 7.16
Provider gets notification of appointment request
Provider confirms or denys appointment
If confirmed user gets notification of confirmed appointment
Appointment editing

TODO for 7.17

Provider gets notification of appointment request
        - check appointments for unconfirmed
        - display unconfirmed appointment with buttons
Provider confirms or denys appointment
        -provider clicks confirm
                -appointment becomes confirmed
                -added to visible provider appointments
        -provider clicks deny
                -appointment object destroyed
                
If confirmed user gets notification of confirmed appointment
Appointment editing

end of day 7.17

Edit form for appointments is done
Need to make method that can get old appointment after "new" one is created
Need to add conditions to check for changed appointments to provider profile
Need to add conditions to check for changed appointment confirmations in client profile

Sort appointments by date on load

Request Appointment Change

        Client fills out request form
        Appointment created with old appointment attributes + changed
        Provider checks for changed appointments on login
        Confirms change
        Client checks for changed and confirmed on login
        Sees confirmation


End of day 7.17


Appointment changes can be requested but can't be confirmed
Cancellation request/notification process


TODO FOR 7.18
Appointment change confirmation
Cancellation request/notification
Provider search

Appointment denial process:
                action          current appointment state
        Client requests                 FFFF
        Provider denies                 FFFT
        Client notified                 destroy


                
        Client requests change           FFTF
        Provider denies change           FFTT
        Client notified                  destroy, old appointment state becomes : TTFF

End of day 7.18
Client denial of a providers request to edit bug
Provider search
Error handling
Fix all failure routes
Done?

GENERAL TODO
Appointment functionality
Error handling
Provider Search
Make all models deletable
Fix all failure routes
Can't access login/registration if logged in


things that would be nice:
Client show page shows all past appointments
Appointment changes just display difference between two appointments. (use reject?)
Provider can search appointments by client
Provider can edit availablity
Provider can add icon to services
Provider calendar
less boring landing page
profile pages seem boring




