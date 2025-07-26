require_relative '../delivery_rule'

module DeliveryRules
  class FreeDeliveryRule < DeliveryRule
    def calculate_delivery_charge(subtotal_after_offers)
      0.0
    end
  end
end