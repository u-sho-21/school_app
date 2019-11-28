# coding: utf-8

require 'faker/japanese'


Teacher.create!( name: "教員",
                 email: "teacher@example.com",
                 password: "password",
                 password_confirmation: "password")

20.times do |n|
  name = Faker::Japanese::Name.last_name
  name2 = Faker::Japanese::Name.first_name
  email = "user#{n+1}@example.com"
  User.create!( name: name,
                name2: name2,
                email: email,
                password: "password",
                password_confirmation: "password")
end

# 1回目のseed

User.all.each do |user|
  name_2 = Faker::Japanese::Name.first_name
  Child.create!( name_1: User.find(user.id).name,
                 name_2: name_2,
                 user_id: user.id,
                 teacher_id: 1)
end

Child.all.each do |child|
  child.update(full_name: "#{child.name_1}#{child.name_2}")
end

# 2回目のseed
