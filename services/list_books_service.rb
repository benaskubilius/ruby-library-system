# frozen_string_literal: true

require_relative '../constants/global_constants'
require_relative '../models/book'

class ListBooksService

  def list_available_books
    books = []
    CSV.foreach(BOOKS_FILE, headers: true) do |row|
      books.push Book.new(row[0], row[1], row[2], row[3], row[4].to_i)
    end

    books.reject do |book|
      book.copies_count.zero?
    end
  end

  def list_user_borrowed_books_ids(username)
    book_ids = []
    File.foreach(BORROWED_BOOKS_FILE) do |line, index|
      next if index == 0

      borrowed_book_information_string = line.chomp.split(',')
      if borrowed_book_information_string[1].include?(username)
        book_ids.push borrowed_book_information_string[0].to_i
      end

    end
    book_ids
  end

end
