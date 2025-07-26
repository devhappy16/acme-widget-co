require_relative "../widget"

module Widgets
  class BlueWidget < Widget
    BLUE_WIDGET = { code: "B01", name: "Blue Widget", price: 7.95 }.freeze

    def initialize
      super(BLUE_WIDGET[:code], BLUE_WIDGET[:name], BLUE_WIDGET[:price])
    end
  end
end
