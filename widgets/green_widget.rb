require_relative '../widget'

module Widgets
  class GreenWidget < Widget
    GREEN_WIDGET = { code: "G01", name: "Green Widget", price: 24.95 }.freeze

    def initialize
      super(GREEN_WIDGET[:code], GREEN_WIDGET[:name], GREEN_WIDGET[:price])
    end
  end
end
