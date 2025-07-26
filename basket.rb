require_relative "widget"

class Cart
  attr_reader :items

  def initialize
    @items = []
  end

  # returns cart information in hash format
  def to_h
    {
      items: @items.map(&:to_h),
      items_count: @items.size,
      subtotal:,
      total:,
    }
  end

  def add(widget_code)
    widget = Widget.find_by_code(widget_code)
    raise ArgumentError, "Invalid item code: #{widget_code}" if widget.nil?
    raise ArgumentError, "Invalid item type: #{widget.class}" unless widget.is_a?(Widget)

    @items << widget

    self
  end

  def subtotal
    @items.sum(&:price)
  end

  def total
    subtotal
  end

  def clear
    @items.clear

    self
  end
end
