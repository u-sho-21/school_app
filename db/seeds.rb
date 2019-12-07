# coding: utf-8

require 'faker/japanese'

#初期書類作成用ユーザー
User.create!(name: "学校", 
             name2:"管理者",
             email: "admon@example.com",
             phone:"111111", 
             password: "password", 
             password_confirmation: "password")

User.create!(name: "学校", 
             name2:"管理者",
             email: "a@a.com",
             phone:"111111", 
             password: "password", 
             password_confirmation: "password")


Teacher.create!( name: "教員",
                 email: "teacher@example.com",
                 password: "password",
                 password_confirmation: "password")

