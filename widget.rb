class Widget
  attr_reader :code, :name, :price

  def initialize(code = nil, name = nil, price = nil)
    @code = code
    @name = name
    @price = price
  end

  def to_s
    "#{name} (#{code}): $#{price}"
  end

  def to_h
    { code:, name:, price: }
  end
end
