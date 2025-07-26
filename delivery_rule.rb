# base/default class for delivery rule

class DeliveryRule
  def calculate_delivery_charge(subtotal_after_offers)
    # default delivery charge logic if not overridden

    return 0.0 if subtotal_after_offers.zero?

    case subtotal_after_offers
    when 1..49.99
      4.95
    when 50..89.99
      2.95
    else
      0.0 # free delivery for orders over $100
    end
  end
end
