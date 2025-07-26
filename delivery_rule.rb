class DeliveryRule
  def calculate_delivery_charge(subtotal_after_offers)
    return 0.0 if subtotal_after_offers.zero? # failsafe check / for digital products?

    case subtotal_after_offers
    when 1..49.99
      4.95
    when 51..89.99
      2.95
    else
      0.0 # subtotal_after_offers more than $90
    end
  end
end
