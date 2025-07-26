require_relative "widget"
require_relative "offers/red_widget_bogo_offer"
require_relative "delivery_rule"

class Basket
  attr_reader :items, :product_catalogue, :offers

  def initialize(product_catalogue = [], offers = [])
    @items = []
    @product_catalogue = product_catalogue # TODO: array of widgets?
    @offers = offers # array of offers
  end

  # returns basket information in hash format
  def to_h
    {
      items: items.map(&:to_h),
      items_count: items.size,
      subtotal:,
      offers_discount:,
      # delivery_cost: delivery_cost,
      total:,
    }
  end

  # method that takes product code as a parameter
  def add(widget_code)
    widget = @product_catalogue.find_by_code(widget_code)
    raise ArgumentError, "Invalid item code: #{widget_code}" if widget.nil?
    raise ArgumentError, "Invalid item type: #{widget.class}" unless widget.is_a?(Widget)

    items << widget

    self
  end

  def subtotal
    items.sum(&:price).round(2)
  end

  def total
    (subtotal - offers_discount + delivery_cost).round(2)
  end

  def clear
    items.clear

    self
  end

  private

  def offers_discount
    total_offer_discount = 0
    return total_offer_discount if offers.size.zero?

    offers.each do |offer|
      total_offer_discount += offer.apply(items).round(2)
    end

    total_offer_discount
  end

  # def delivery_cost
  #   subtotal_after_offers = subtotal - offers_discount
  #   delivery_rule = DeliveryRule.new
  #   delivery_rule.calculate_delivery_charge(subtotal_after_offers)
  # end
end
