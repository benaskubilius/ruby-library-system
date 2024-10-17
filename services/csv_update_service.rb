# frozen_string_literal: true

require_relative '../constants/global_constants'
require_relative '../enums/copies_count_action'

class CsvUpdateService

  def manage_book_available_copies_count(id, action)
    all_books = retrieve_all_books
    founded_book = find_update_needed_book(all_books, id)
    update_copies_count(founded_book, action)

    CSV.open(BOOKS_FILE, 'wb') do |csv|
      csv << %w[id,title,author,release_date,copies]
      all_books.each do |book|
        csv << [book.id, book.title, book.author, book.release_date, book.copies_count]
      end
    end
  end

  private

  def retrieve_all_books
    all_books = []
    CSV.foreach(BOOKS_FILE, headers: true) do |row|
      all_books.push Book.new(row[0], row[1], row[2], row[3], row[4].to_i)
    end
    all_books
  end

  def find_update_needed_book(books, id)
    books.find do |book|
      book.id == id
    end
  end

  def update_copies_count(book, action)
    if action == CopiesCountAction::INCREASE
      book.copies_count += 1
    elsif action == CopiesCountAction::DECREASE
      book.copies_count -= 1
    end
  end

end
