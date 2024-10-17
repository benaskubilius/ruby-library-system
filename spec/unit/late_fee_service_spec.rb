# frozen_string_literal: true

require_relative '../../services/late_fee_calculator_service'
require 'date'
require_relative '../../constants/global_constants'

RSpec.describe LateFeeCalculatorService do
  describe '#late_fee_calculation' do

    it 'debt should be zero as borrow date less than month' do
      late_fee_calculator_service = LateFeeCalculatorService.new

      debt = late_fee_calculator_service.calculate(Date.today - 1)

      expect(debt).to eq(0)
    end

    it 'debt should not be zero as borrow date less than month' do
      late_fee_calculator_service = LateFeeCalculatorService.new

      debt = late_fee_calculator_service.calculate(Date.today - 60)

      expect(debt).to eq(30*LATE_FEE_FOR_DAY)
    end
  end

end
