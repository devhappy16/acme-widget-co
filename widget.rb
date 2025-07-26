class Widget
  attr_reader :code, :name, :price

  RED_WIDGET = { code: "R01", name: "Red Widget", price: 32.95 }.freeze
  GREEN_WIDGET = { code: "G01", name: "Green Widget", price: 24.95 }.freeze
  BLUE_WIDGET = { code: "B01", name: "Blue Widget", price: 7.95 }.freeze

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end

  def to_s
    "#{@name} (#{@code}): $#{@price}"
  end

  def to_h
    {
      code: @code,
      name: @name,
      price: @price
    }
  end

  # class methods for utility

  # returns instance of all widgets in a memoized hash
  def self.all_widgets
    @all_widgets ||= [RED_WIDGET, GREEN_WIDGET, BLUE_WIDGET].each_with_object({}) do |widget_data, all_widget_hash|
      widget_instance = new(widget_data[:code], widget_data[:name], widget_data[:price])
      all_widget_hash[widget_data[:code]] = widget_instance
    end
  end

  def self.find_by_code(code)
    all_widgets[code]
  end
end
