#!/usr/bin/ruby

require 'sinatra'
require 'sinatra/reloader'
require 'sass'
require './students.rb'
require './comment.rb'


configure do
  enable :sessions
  set :username, 'sinatra'
  set :password, 'assignment'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  DataMapper.auto_migrate!
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_migrate!
end

get '/' do
  @title = "Home page"
  erb :home
end

get '/login' do
  erb :login
end

post '/login' do
  if params['login']['username'] == 'sinatra' && params['login']['password'] == 'assignment'
    session[:admin] = true
    redirect to ('/')
  else
    erb :login
  end
end

get '/logout' do
  session[:admin] = nil
  redirect to ('/')
end

get '/about' do
  @title = "About"
  erb :about
end

get '/contact' do
  @title = "Contact Us"
  erb :contact
end

get '/video' do
  redirect ('/login') unless session[:admin]
  @title = "Video"
  erb :video
end
