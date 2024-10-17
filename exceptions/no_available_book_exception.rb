# frozen_string_literal: true

class NoAvailableBookException < StandardError
  def initialize(msg = 'There is no available book to borrow with specified ID')
    super
  end
end
