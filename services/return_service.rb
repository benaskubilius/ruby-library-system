# frozen_string_literal: true

require_relative '../enums/copies_count_action'
require_relative '../constants/global_constants'
require_relative 'late_fee_calculator_service'
require_relative 'csv_update_service'
require_relative '../exceptions/no_borrowed_book_exception'

class ReturnService

  def return_book(id, username)
    id = id.to_s
    check_is_book_borrowed(id, username)
    line_to_delete = "#{id},#{username}"
    rejected_line = nil
    found = false

    filtered_lines = File.foreach(BORROWED_BOOKS_FILE).reject do |line|
      if line.include?(line_to_delete) && !found
        rejected_line = line
        found = true
      else
        false
      end
    end
    manage_late_fee(rejected_line)
    write_to_file(filtered_lines)
    csv_update_service = CsvUpdateService.new
    csv_update_service.manage_book_available_copies_count(id, CopiesCountAction::INCREASE)
  end

  private

  def check_is_book_borrowed(book_id, username)
    list_books_service = ListBooksService.new
    identified_book = list_books_service.list_user_borrowed_books_ids(username).find do |id|
      id == book_id.to_i
    end

    if identified_book.nil?
      raise NoBorrowedBookException
    end
  end

  def manage_late_fee(rejected_line)
    string_date = rejected_line.chomp.split(',')[2]
    date = Date.parse string_date
    late_fee_calculator_service = LateFeeCalculatorService.new
    debt = late_fee_calculator_service.calculate(date)

    if debt > 0
      puts "You owe #{debt}€ for late return of a book"
    end
  end

  def write_to_file(filtered_lines)
    File.open(BORROWED_BOOKS_FILE, 'w') do |file|
      file.puts(filtered_lines)
    end
  end

end
