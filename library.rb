# frozen_string_literal: true

require 'table_print'
require_relative './models/book'
require_relative './models/user'
require_relative './constants/global_constants'
require_relative './services/list_books_service'
require_relative './services/borrow_service'
require_relative './services/return_service'
require_relative './services/user_service'

puts 'Library System initialized'
puts 'Enter your username:'
username = gets.chomp
if username == ''
  puts 'Exiting...'
  abort
end
user_service = UserService.new
is_user_exists = user_service.find_user(username)
if is_user_exists
  puts 'Enter your password:'
  password = gets.chomp
  if is_user_exists.password == password
    puts "Hello, #{username}"
  else
    puts 'Wrong password! Exiting...'
    abort
  end
else
  puts "No user with #{username} username found."
  puts 'Do you want to create user (Y/n)?'
  creation_choice = gets.chomp.downcase
  if creation_choice == 'y'
    puts 'Please create password:'
    new_password = gets.chomp
    new_user = User.new(username, new_password)
    user_service.add_user(new_user)
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

  begin
    case action
    when '1'
      list_books_service = ListBooksService.new
      tp list_books_service.list_available_books, :except => :display_to_string
    when '2'
      puts 'Please write book ID you want to borrow'
      requested_book_id = gets.chomp
      borrow_service = BorrowService.new
      borrow_service.borrow_book(requested_book_id, username)
    when '3'
      puts 'Please write book ID you want to return'
      returned_book_id = gets.chomp
      return_service = ReturnService.new
      return_service.return_book(returned_book_id, username)
    when '4'
      puts 'Exiting...'
      abort
    else
      puts 'Please select valid action'
    end

  rescue NoAvailableBookException => e
    puts e.message
  rescue NoBorrowedBookException => e
    puts e.message
  rescue => e
    e.message
  end
end
