class Offer
  ACTIVE_OFFER_CODES = %w[RED_BOGOHALF].freeze

  attr_reader :code

  def initialize(offer_code = nil)
    @code = offer_code
    @description = "Buy one red widget, get the second half price."
  end

  def apply(items)
    return 0 unless ACTIVE_OFFER_CODES.include?(code)

    red_widget_count = items.count { |item| item.code == Widget::RED_WIDGET[:code] }
    return 0 if red_widget_count < 2

    # for every 2 red widgets, the second one gets 50% discount
    # e.g. if there are 4 red widgets (per widget price is $1)
    #
    # trace 1: 4 red widgets => pairs: 4 / 2 = 2
    # discount for each pair = 1 * 0.5 = 0.5
    # discount for 2 pairs = 2 * 0.5 = 1.0
    #
    # trace 2: 6 red widgets => pairs: 6 / 2 = 3
    # discount for each pair = 1 * 0.5 = 0.5
    # discount for 3 pairs = 3 * 0.5 = 1.5
    #
    # trace 3: 5 red widgets => pairs: 5 / 2 = 2
    # same as trace 1 with 1 widget unpaired
    #
    # trace 3: 7 red widgets => pairs: 7 / 2 = 3
    # discount for each pair = 1 * 0.5 = 0.5
    # discount for 3 pairs = 3 * 0.5 = 1.5

    number_of_red_widget_pairs = red_widget_count / 2 # integer division
    discount_amount_per_pair = Widget::RED_WIDGET[:price] * 0.5

    (number_of_red_widget_pairs * discount_amount_per_pair).round(2)
  end
end
