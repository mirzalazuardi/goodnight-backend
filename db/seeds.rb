# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Timecop.freeze(14.days.ago.beginning_of_day)

u1 = User.create!(name: 'Mirzalazuardi')
u2 = User.create!(name: Faker::Name.name)
u3 = User.create!(name: Faker::Name.name)
u4 = User.create!(name: Faker::Name.name)
u5 = User.create!(name: Faker::Name.name)
u6 = User.create!(name: Faker::Name.name)
u7 = User.create!(name: Faker::Name.name)
u8 = User.create!(name: Faker::Name.name)

#user who not follow each other to user1 (user_ids: 2, 4, 6) #not friend
Follower.create!(follower_id: u2.id, user_id: u1.id)
Follower.create!(follower_id: u4.id, user_id: u1.id)
Follower.create!(follower_id: u6.id, user_id: u1.id)

#user who follow each other to user1 (user_ids: 3, 5, 7) #friend
Follower.create!(follower_id: u3.id, user_id: u1.id)
Follower.create!(follower_id: u5.id, user_id: u1.id)
Follower.create!(follower_id: u7.id, user_id: u1.id)
Follower.create!(follower_id: u1.id, user_id: u3.id)
Follower.create!(follower_id: u1.id, user_id: u5.id)
Follower.create!(follower_id: u1.id, user_id: u7.id)

Sleep.clock(u1.id)
Sleep.clock(u7.id)
Timecop.freeze(1.hour)
Sleep.clock(u1.id)
Sleep.clock(u7.id) # exclude because out of date range
Timecop.freeze(7.days)
Sleep.clock(u1.id)
Sleep.clock(u2.id) 
Sleep.clock(u4.id)
Sleep.clock(u3.id)
Sleep.clock(u5.id)

Timecop.freeze(1.hour)
Sleep.clock(u2.id)
Sleep.clock(u4.id)
Timecop.freeze(2.hour)
Sleep.clock(u1.id)
Sleep.clock(u3.id) # count in
Timecop.freeze(5.hour)
Sleep.clock(u5.id) # count in
Timecop.return
