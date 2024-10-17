# frozen_string_literal: true

require_relative '../constants/global_constants'

class LateFeeCalculatorService

  def calculate(date)
    today_date = Date.today
    debt = 0
    borrowing_period = (today_date - date).to_i
    if borrowing_period > 30
      debt = (borrowing_period - 30) * LATE_FEE_FOR_DAY
    end

    debt
  end
end
