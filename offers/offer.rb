class Offer
  # ideally should have a hash of valid offer codes with valid_from and valid_until
  # or similar conditional parameters but using a constant for simplicity for now;
  # simply remove the offer code to invalidate the offer
  VALID_OFFER_CODES = %w[BOGO_RED_WIDGET].freeze

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
    unless valid_offer_code?(offer_code)
      raise ArgumentError, "Invalid offer code: #{offer_code}"
    end
  end

  def valid_offer_code?(code)
    VALID_OFFER_CODES.include?(code)
  end
end