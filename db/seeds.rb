
tony = Provider.create(name: "Tony Barberino", email: "tbarberino@gmail.com", business_name: "Tony's Barbershop", location: "New Jersey",password: "password123", phone_number: "555-555-5555")
jon = Client.create(name: "Jonathan Bleibdery", email: "jbleibdery@gmail.com", password: "password123", location: "New Jersey", phone_number: "555-543-6789")
tony.services << Service.create(name: "Haircut", description: "Shampoo, scalp massage, condition, neck/shoulder rub, brow and ear trim, hot lather neck shave, haircut and style with product, included.", price: 40)
tony.services << Service.create(name: "Detail", description: "Clean up side burns, ears, and neck plus reshape with internal texturing, brow and ear trim and a style with product.", price: 20)
tony.services << Service.create(name: "Clean Up", description: "For our existing clients.  We’ll cut around the ears, back of neck, hairline and hot lather shave, so you don’t have to do it yourself.", price: 7)
tony.services << Service.create(name: "Shave", description: "Featuring hot towels, prep oil with lather, straight razor and aftershave.", price: 25)
jon.appointments.build(provider: tony, services: tony.services, date: DateTime.now)
jon.save

