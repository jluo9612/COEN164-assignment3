#!/usr/bin/ruby

require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-validations'

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :value, String
  property :created_at, DateTime
end

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

DataMapper.finalize

get '/comments' do
  redirect("/login") unless session[:admin]
  @title= "Comments"
  @comments = Comment.all
  erb :comment
end

get '/comments/new' do
  redirect("/login") unless session[:admin]
  @title= "Comments"
  @comments = Comment.new
  erb :new_comment
end

get '/comments/:id' do
  redirect("/login") unless session[:admin]
  @title= "Comments"
  @comments = Comment.get(params[:id])
  erb :comment_info
end

post '/comments' do
  redirect("/login") unless session[:admin]
  comments = Comment.create(params['comments'])
  redirect to("/comments")
end

put '/comments/:id' do
  redirect("/login") unless session[:admin]
  comments = Comment.get(params[:id])
  comments.update(params['comments'])
  redirect to("/comments/#{comments.id}")
end

delete '/comments/:id' do
  redirect ('/login') unless session[:admin]
  Comment.get(params[:id]).destroy
  redirect to('/comments')
end
