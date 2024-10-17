# frozen_string_literal: true

require_relative '../models/user'
require_relative '../constants/global_constants'
require_relative '../repositories/user_repository'

class UserService

  def initialize
    @user_repo = UserRepository.new
  end

  def find_user(username)
    user = @user_repo.find_user(username)
    if user != nil
      user
    else
      false
    end
  end

  def add_user(new_user)
    @user_repo.add_user(new_user)
  end
end
