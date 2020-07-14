mitch = Client.create(name: "Mitch Reitman", email: "mreitman@gmail.com", password: "password123", location: "Milwaukee", phone_number: "414-543-6789")
jim = Client.create(name: "Jimmy LaDue", email: "jladue@gmail.com", password: "password123", location: "Milwaukee", phone_number: "414-666-6789")
liv = Client.create(name: "Olivia Banks", email: "obanks@gmail.com", password: "password123", location: "Milwaukee", phone_number: "414-543-6666")
denise = Provider.create(name: "Denise Lasher", email: "dlasher@gmail.com", business_name: "Lashes By Denise", password: "password123", phone_number: "555-555-5555")
erin = Provider.create(name: "Erin Pumper", email: "epumper@gmail.com", business_name: "Lips By Erin", password: "password123", phone_number: "555-555-5555")
denise.services.build(name: "lashes", price: 20)
denise.save
denise.services.build(name: "full volume lashes", price: 30)
denise.save
erin.services.build(name: "lips", price: 200)
erin.save
erin.services.build(name: "huge lips", price: 300)
erin.save
mitch.appointments.build(provider: denise, services: denise.services, date: DateTime.now)
mitch.save
mitch.appointments.build(provider: erin, services: denise.services, date: DateTime.now)
mitch.save
jim.appointments.build(provider: denise, services: denise.services, date: DateTime.now)
jim.save
jim.appointments.build(provider: erin, services: denise.services, date: DateTime.now)
jim.save
liv.appointments.build(provider: denise, services: denise.services, date: DateTime.now)
liv.save
liv.appointments.build(provider: erin, services: denise.services, date: DateTime.now)
liv.save
