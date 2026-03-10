# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: ruby 3.2.2

* System dependencies: Rails 8.1.2

* Configuration

* Database creation : rails db:create

* Database initialization rails db:migrate

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

Endpoints:

* create user:

POST http://127.0.0.1:3000/api/v1/users

{
    "email": "mrunal.selokar.20+2@gmail.com",
    "full_name": "Mrunal Selokar",
    "posts_attributes": [
        {
        "title": "second"
        },{
            "title": "third"
        }
    ]
}

* get posts:

GET http://127.0.0.1:3000/api/v1/users/:user_id/posts

* create post:

POST http://127.0.0.1:3000/api/v1/users/:user_id/posts
