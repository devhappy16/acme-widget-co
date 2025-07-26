require_relative "../offer"
require_relative "../widgets/red_widget"

module Offers
  class RedWidgetBogoOffer < Offer
    def apply(items)
      red_widget_count = items.count { |item| item.code == Widgets::RedWidget::RED_WIDGET[:code] }
      return 0 if red_widget_count < 2

      # for every 2 red widgets, the second one gets 50% discount
      #
      # e.g. 1 widget price is $1 => discount for each pair is $0.50
      #
      # trace 1: 4 red widgets => pairs: 4 / 2 = 2
      # discount for 2 pairs = 2 * 0.5 = 1.
      #
      # trace 2: 6 red widgets => pairs: 6 / 2 = 3
      # discount for 3 pairs = 3 * 0.5 = 1.5
      #
      # trace 3: 5 red widgets => pairs: 5 / 2 = 2
      # same as trace 1 with 1 widget unpaired
      #
      # trace 4: 7 red widgets => pairs: 7 / 2 = 3
      # same as trace 2 with 1 widget unpaired

      number_of_red_widget_pairs = red_widget_count / 2 # integer division
      discount_amount_per_pair = Widgets::RedWidget::RED_WIDGET[:price] * 0.5

      (number_of_red_widget_pairs * discount_amount_per_pair).round(2) # total discount
    end

    def offer_code
      "BOGO_RED_WIDGET"
    end

    def description
      "Buy one red widget, get the second half price."
    end
  end
end
