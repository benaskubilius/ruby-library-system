# frozen_string_literal: true

require 'csv'

USER_FILE = './storage/users.db'
BORROWED_BOOKS_FILE = './storage/borrowed_books.db'
BOOKS_FILE = './storage/books.csv'


class User
  attr_accessor :username, :password

  def initialize(username, password)
    @username = username
    @password = password
  end

  def to_string
    "#{username},#{password}\n"
  end
end

def find_user(username)
  users = []
  File.foreach(USER_FILE) do |line, index|
    next if index == 0

    user_string = line.chomp.split(',')
    users.push User.new(user_string[0], user_string[1])
  end

  user = users.find do |user|
    user.username == username
  end
  user || false
end

def add_user(new_user)
  File.write(USER_FILE, new_user.to_string, mode: 'a')
end


puts 'Library System initialized'
puts 'Enter your username:'

username = gets.chomp
if username == ''
  puts 'Exiting...'
  abort
end
is_user_exists = find_user(username)
if is_user_exists
  puts 'Enter your password:'
  password = gets.chomp
  if is_user_exists.password == password
    puts "Hello, #{@username}"
  else
    puts 'Wrong password! Exiting...'
  end
else
  puts "No user with #{@username} username found."
  puts 'Do you want to create user (Y/n)?'
  creation_choice = gets.chomp.downcase
  if creation_choice == 'y'
    puts 'Please create password:'
    new_password = gets.chomp
    new_user = User.new(username, new_password)
    add_user(new_user)
  else
    puts 'Exiting...'
    abort
  end
end

