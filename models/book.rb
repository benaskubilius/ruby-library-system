# frozen_string_literal: true

class Book
  attr_accessor :id, :title, :author, :release_date, :copies_count

  def initialize(id, title, author, release_date, copies_count)
    @id = id
    @title = title
    @author = author
    @release_date = release_date
    @copies_count = copies_count
  end

  def display_to_string
    "#{id} | #{title} | #{author} | #{release_date} | #{copies_count}\n"
  end

end