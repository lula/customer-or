# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Season.delete_all

User.create(email: "admin@cor.it", password: "admin", password_confirmation: "admin", roles: [:admin]) unless User.where(email: "admin@cor.it").length > 0
User.create(email: "lula@cor.it", password: "lula", password_confirmation: "lula", roles: [:user]) unless User.where(email: "lula@cor.it").length > 0

Season.create(country: "", description: "Spring", start_on: Time.new(2013,3,21), end_on: Time.new(2013, 6, 20))
Season.create(country: "", description: "Summer", start_on: Time.new(2013, 6, 21), end_on: Time.new(2013, 9, 20))
Season.create(country: "", description: "Autumn", start_on: Time.new(2013, 9, 21), end_on: Time.new(2013, 12, 21))
Season.create(country: "", description: "Winter", start_on: Time.new(2013, 12, 21), end_on: Time.new(2013, 3, 21))

Season.create(country: "nl", description: "Spring NL", start_on: Time.new(2013,3,21), end_on: Time.new(2013, 6, 20))
Season.create(country: "nl", description: "Summer NL", start_on: Time.new(2013, 6, 1), end_on: Time.new(2013, 9, 20))
Season.create(country: "nl", description: "Autumn NL", start_on: Time.new(2013, 8, 15), end_on: Time.new(2013, 12, 21))
Season.create(country: "nl", description: "Winter NL", start_on: Time.new(2013, 12, 21), end_on: Time.new(2013, 3, 21))