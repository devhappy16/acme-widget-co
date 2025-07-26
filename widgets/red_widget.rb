require_relative '../widget'

module Widgets
  class RedWidget < Widget
    RED_WIDGET = { code: "R01", name: "Red Widget", price: 32.95 }.freeze

    def initialize
      super(RED_WIDGET[:code], RED_WIDGET[:name], RED_WIDGET[:price])
    end
  end
end
