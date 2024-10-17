# frozen_string_literal: true

require "sqlite3"

class UserRepository

  def initialize
    @db = SQLite3::Database.open("users.db")
    @db.execute("CREATE TABLE IF NOT EXISTS users(username TEXT NOT NULL PRIMARY KEY, password TEXT)")
  end

  def find_user(username)
    query = "SELECT * FROM users WHERE username = ?;"
    user = @db.get_first_row(query, username)
    if user != nil
      User.new(user[0], user[1])
    else
      nil
    end
  end

  def add_user(new_user)
    @db.execute "INSERT INTO users (username, password) VALUES (?, ?)", [new_user.username, new_user.password]
  end

  def close
    if @db
      @db.close
    end
  end

end
