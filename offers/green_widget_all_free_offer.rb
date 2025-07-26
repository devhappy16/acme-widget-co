require_relative "../offer"

module Offers
  class GreenWidgetAllFreeOffer < Offer
    def apply(items)
      return 0.0 if items.empty?

      green_widgets = items.select { |item| item.code == Widgets::GreenWidget::GREEN_WIDGET[:code] }
      green_widgets.sum(&:price).round(2)
    end

    def offer_code
      "FREE_GREEN_WIDGET"
    end

    def description
      "All green widgets are free."
    end
  end
end
