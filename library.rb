# frozen_string_literal: true

require 'csv'

USER_FILE = './storage/users.db'
BORROWED_BOOKS_FILE = './storage/borrowed_books.db'
BOOKS_FILE = './storage/books.csv'

class Book
  attr_accessor :id, :title, :author, :release_date, :copies_count

  def initialize(id, title, author, release_date, copies_count)
    @id = id
    @title = title
    @author = author
    @release_date = release_date
    @copies_count = copies_count
  end

  def display_to_string
    "#{id} | #{title} | #{author} | #{release_date} | #{copies_count}\n"
  end

end

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

def list_available_books
  books = []
  CSV.foreach(BOOKS_FILE, headers: true) do |row|
    books.push Book.new(row[0], row[1], row[2], row[3], row[4].to_i)
  end

  books.reject do |book|
    book.copies_count == 0
  end
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

action = 0
while action != 4
  puts "\n"
  puts 'Select action'
  puts '1 - List available books'
  puts '2 - Borrow a book'
  puts '3 - Return a book'
  puts '4 - Exit'
  puts "\n"
  action = gets.chomp

  case action
  when '1'
    puts 'ID | Title | Author | Release date | Available copies'
    list_available_books.each { |book| puts book.display_to_string }
  when '4'
    puts 'Exiting...'
    abort
  else
    puts 'Please select valid action'
  end
end
