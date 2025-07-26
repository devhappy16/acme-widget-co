require_relative "widget"
require_relative "product_catalogue"
require_relative "offer"
require_relative "delivery_rule"

class Basket
  CURRENCY_CODE = "$"
  attr_reader :items, :product_catalogue, :offers, :delivery_rule

  def initialize(product_catalogue = nil, offers = [], delivery_rule = nil)
    @product_catalogue = product_catalogue || ProductCatalogue.new # Default catalogue with all widgets
    @offers = offers # array of offers to allow multiple offer support
    @delivery_rule = delivery_rule || DeliveryRule.new # fallback to default delivery rule

    @items = []
  end

  # returns basket information in hash format
  def to_h
    {
      items: items.map(&:to_h),
      items_count: items.size,
      subtotal:,
      offers_discount_amount:,
      delivery_cost:,
      total:
    }
  end

  # method that takes product code as a parameter
  def add(widget_code)
    # Find widget from the product catalogue
    widget = @product_catalogue.find_by_code(widget_code)

    if widget
      @items << widget
    else
      raise ArgumentError, "Widget with code #{widget_code} not found in product catalogue"
    end
  end

  def subtotal
    items.sum(&:price).round(2)
  end

  # final total after offers discount and adding delivery cost
  def total
    (subtotal - offers_discount_amount + delivery_cost).round(2)
  end

  def total_with_currency
    "#{CURRENCY_CODE}#{'%.2f' % total}"
  end

  def clear
    items.clear

    self
  end

  private

  def delivery_cost
    subtotal_after_offers = subtotal - offers_discount_amount
    delivery_rule.calculate_delivery_charge(subtotal_after_offers).round(2)
  end

  def offers_discount_amount
    total_offers_discount_amount = 0
    return total_offers_discount_amount if offers.size.zero?

    # IMPORTANT: apply offers in the order of ACTIVE_OFFER_CODES precedence
    ordered_offers = Offer::ACTIVE_OFFER_CODES
      .map { |code| offers.find { |offer| offer.offer_code == code } }
      .compact

    ordered_offers.each do |offer|
      total_offers_discount_amount += offer.apply(items).round(2)
    end

    total_offers_discount_amount
  end
end
