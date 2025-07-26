# base offer class

class Offer
  ACTIVE_OFFER_CODES = %w[BOGO_RED_WIDGET].freeze

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
