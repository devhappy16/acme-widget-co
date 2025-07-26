require_relative "widget"
require_relative "offer"
require_relative "delivery_rule"

class Basket
  attr_reader :items

  def initialize(product_catalogue = nil, delivery_rules = nil, offers = nil)
    @items = []
    @product_catalogue = product_catalogue || Widget
    @delivery_rules = delivery_rules || DeliveryRule.new
    @offers = offers || Offer.new
  end

  # returns basket information in hash format
  def to_h
    {
      items: @items.map(&:to_h),
      items_count: @items.size,
      subtotal:,
      offers_discount: calculate_offers_discount,
      delivery_cost: calculate_delivery_cost,
      total:,
    }
  end

  # method that takes product code as a parameter
  def add(widget_code)
    widget = @product_catalogue.find_by_code(widget_code)
    raise ArgumentError, "Invalid item code: #{widget_code}" if widget.nil?
    raise ArgumentError, "Invalid item type: #{widget.class}" unless widget.is_a?(Widget)

    @items << widget

    self
  end

  def subtotal
    @items.sum(&:price)
  end

  def total
    subtotal - calculate_offers_discount + calculate_delivery_cost
  end

  def clear
    @items.clear

    self
  end

  private

  def calculate_offers_discount
    @offers.apply(@items)
  end

  def calculate_delivery_cost
    subtotal_after_offers = subtotal - calculate_offers_discount
    @delivery_rules.calculate_cost(subtotal_after_offers)
  end
end
