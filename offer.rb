# base offer class

class Offer
  ACTIVE_OFFER_CODES = %w[BOGO_RED_WIDGET].freeze
  # if multiple offers, the offer discount is calculated based on the order/sequence of
  # offer codes defined in this constant; check basket.rb#offers_discount_amount
  # ideally, the precedence of offer code should have a different calculation logic
  # as it can be a complicated part for an application like this

  def initialize
    validate_offer_code!
  end

  def apply(items)
    raise NotImplementedError, "Subclasses must implement the apply method"
  end

  def offer_code
    raise NotImplementedError, "Subclasses must implement the offer_code method"
  end

  def description
    raise NotImplementedError, "Subclasses must implement the description method"
  end

  private

  def validate_offer_code!
    raise ArgumentError, "Invalid offer code: #{offercode}." unless ACTIVE_OFFER_CODES.include?(offer_code)
  end
end
