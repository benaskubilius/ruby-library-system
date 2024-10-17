# frozen_string_literal: true

require_relative 'csv_update_service'
require_relative 'list_books_service'
require_relative '../constants/global_constants'
require_relative '../exceptions/no_available_book_exception'

class BorrowService
  def borrow_book(id, username)
    id = id.to_s
    check_book_availability(id)
    File.write(BORROWED_BOOKS_FILE, "#{id},#{username},#{Time.now.strftime('%Y-%m-%d')}\n", mode: 'a')
    csv_update_service = CsvUpdateService.new
    csv_update_service.manage_book_available_copies_count(id, CopiesCountAction::DECREASE)
  end

  private

  def check_book_availability(id)
    list_books_service = ListBooksService.new
    identified_book = list_books_service.list_available_books.find do |book|
      book.id == id
    end
    if identified_book.nil?
      raise NoAvailableBookException
    end
  end

end
