#!/usr/bin/ruby

require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :lastName, String, :required=>true
  property :firstName, String, :required=>true
  property :address, Text, :required=>true
  property :birthday, Date, :required=>true
end

configure do
  enable :sessions
  set :username, 'sinatra'
  set :password, 'assignment'
end

DataMapper.finalize

get '/students' do
  redirect ('/login') unless session[:admin]
  @title = "Students"
  @students = Student.all
  erb :students
end

get '/students/new' do
  redirect ('/login') unless session[:admin]
  @title = "Students"
  @students = Student.new
  erb :new_student
end

get '/students/:id' do
  redirect ('/login') unless session[:admin]
  @title = "Students"
  @students = Student.get(params[:id])
  erb :student_info
end

get '/students/:id/edit' do
  redirect ('/login') unless session[:admin]
  @title = "Students"
  @students = Student.get(params[:id])
  if @students
    puts(@students.firstName, @students.lastName, @students.id)
  else
    puts("Student not found")
  end
  erb :edit_students
end

post '/students' do
  redirect ('/login') unless session[:admin]
  students = Student.create(params['students'])
  redirect to("/students/#{students.id}")
end

put '/students/:id' do
  redirect ('/login') unless session[:admin]
  students = Student.get(params[:id])
  students.update(params['students'])
  redirect to("/students/#{students.id}")
end

delete '/students/:id' do
  redirect ('/login') unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
