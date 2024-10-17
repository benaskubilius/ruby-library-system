# frozen_string_literal: true

require_relative '../models/user'
require_relative '../constants/global_constants'

class UserService

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
end
