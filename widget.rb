class Widget
  attr_reader :code, :name, :price

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
end
