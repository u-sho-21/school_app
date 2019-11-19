# coding: utf-8

User.create!( name: "Sample User",
              email: "sample@email.com",
              password: "password",
              password_confirmation: "password")

Teacher.create!( name: "教師",
                 email: "teacher@example.com",
                 password: "password",
                 password_confirmation: "password")
