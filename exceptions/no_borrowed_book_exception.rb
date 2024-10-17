# frozen_string_literal: true

class NoBorrowedBookException < StandardError
  def initialize(msg = 'You do not have any borrowed book to return with specified ID')
    super
  end
end
