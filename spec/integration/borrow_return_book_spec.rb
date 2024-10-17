# frozen_string_literal: true

require 'rspec'
require_relative '../../services/borrow_service'
require_relative '../../services/return_service'
require_relative '../../exceptions/no_borrowed_book_exception'
require_relative '../../exceptions/no_available_book_exception'


RSpec.describe 'BorrowReturnBook' do
  let(:borrow_service) { BorrowService.new }
  let(:return_service) { ReturnService.new }
  let(:user_service) { UserService.new }
  let(:user) { User.new('test', 'test') }

  before(:all) do
    user_service.add_user(user)
  end

  after(:all) do
    user_service.remove_user(user.username)
  end

  it 'borrows and returns the same book successfully' do
    expect { borrow_service.borrow_book(1, user.username) }.not_to raise_error
    expect { return_service.return_book(1, user.username) }.not_to raise_error
  end

  it 'raises NoAvailableBookException when borrowing a non-available book' do
    expect { borrow_service.borrow_book(999, user.username) }.to raise_error(NoAvailableBookException)
  end

  it 'raises NoBorrowedBookException when returning a non-borrowed book' do
    expect { return_service.return_book(999, user.username) }.to raise_error(NoBorrowedBookException)
  end

end
