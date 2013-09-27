# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User.create(email: "admin@admin.it", password: "admin", password_confirmation: "admin", roles: [:admin])
# User.create(email: "lula@lula.it", password: "lula", password_confirmation: "lula", roles: [:user])

Season.create(country: "", description: "Spring", start_on: Time.new(2013,3,21), end_on: Time.new(2013, 6, 20))
Season.create(country: "", description: "Summer", start_on: Time.new(2013, 6, 21), end_on: Time.new(2013, 9, 20))
Season.create(country: "", description: "Autumn", start_on: Time.new(2013, 9, 21), end_on: Time.new(2013, 12, 21))
Season.create(country: "", description: "Winter", start_on: Time.new(2013, 12, 21), end_on: Time.new(2013, 3, 21))