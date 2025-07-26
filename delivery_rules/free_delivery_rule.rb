require_relative '../delivery_rule'

class FreeDeliveryRule < DeliveryRule
  def calculate_delivery_charge(subtotal_after_offers)
    0.0
  end

  def description
    "Free delivery on all orders. No conditions apply."
  end
end
