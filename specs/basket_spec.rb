require "rspec"
require_relative "../basket"
require_relative "../product_catalogue"
require_relative "../offers/red_widget_bogo_offer"
require_relative "../delivery_rules/free_delivery_rule"

RSpec.describe "Acme Widget Co Basket Test" do
  let(:product_catalogue) { ProductCatalogue.new }
  let(:free_delivery) { DeliveryRules::FreeDeliveryRule.new }
  let(:bogo_red_offer) { Offers::RedWidgetBogoOffer.new }

  let(:red_widget_code) { Widgets::RedWidget::RED_WIDGET[:code] }
  let(:green_widget_code) { Widgets::GreenWidget::GREEN_WIDGET[:code] }
  let(:blue_widget_code) { Widgets::BlueWidget::BLUE_WIDGET[:code] }

  describe "Product Catalogue" do
    it "contains the three required products with correct prices" do
      red_widget = product_catalogue.find_by_code("R01")
      green_widget = product_catalogue.find_by_code("G01")
      blue_widget = product_catalogue.find_by_code("B01")

      expect(red_widget.name).to eq("Red Widget")
      expect(red_widget.price).to eq(32.95)

      expect(green_widget.name).to eq("Green Widget")
      expect(green_widget.price).to eq(24.95)

      expect(blue_widget.name).to eq("Blue Widget")
      expect(blue_widget.price).to eq(7.95)
    end
  end

  describe "Delivery Rules" do
    describe "DeliveryRules::FreeDeliveryRule" do
      it "provides free delivery for all orders" do
        expect(free_delivery.calculate_delivery_charge(0)).to eq(0.0)
        expect(free_delivery.calculate_delivery_charge(25.00)).to eq(0.0)
        expect(free_delivery.calculate_delivery_charge(50.00)).to eq(0.0)
        expect(free_delivery.calculate_delivery_charge(100.00)).to eq(0.0)
      end
    end

    describe "Default DeliveryRule" do
      it "calculates delivery charges correctly" do
        delivery_rule = DeliveryRule.new

        expect(delivery_rule.calculate_delivery_charge(0)).to eq(0.0)
        expect(delivery_rule.calculate_delivery_charge(25.00)).to eq(4.95)
        expect(delivery_rule.calculate_delivery_charge(50.00)).to eq(2.95)
        expect(delivery_rule.calculate_delivery_charge(100.00)).to eq(0.0)
      end
    end
  end

  # test if the pairs calculation is working correctly
  describe "Red Widget Only Basket With Buy One Get Other Half Price Offer" do
    let(:basket) { Basket.new(product_catalogue, [bogo_red_offer], free_delivery) }

    it "applies no discount for single red widget" do
      basket.add(red_widget_code)
      expect(basket.total).to eq(32.95)
    end

    it "applies BOGO offer for a pair of red widgets" do
      basket.add(red_widget_code)
      basket.add(red_widget_code)
      # Subtotal: 2 * 32.95 = 65.90
      # After BOGO discount: 65.90 - (32.95 * 0.5) = 49.42
      expect(basket.total).to eq(49.42)
    end

    it "applies BOGO offer for multiple pairs correctly" do
      basket.add(red_widget_code)
      basket.add(red_widget_code)
      basket.add(red_widget_code)
      basket.add(red_widget_code)

      # Subtotal: 4 * 32.95 = 131.80
      # BOGO discount for 2 pairs: 2 * (32.95 * 0.5) = 32.95
      # Total: 131.80 - 32.95 = 98.85
      expect(basket.total).to eq(98.85)
    end

    it "handles odd numbers correctly applying BOGO only to pairs" do
      basket.add(red_widget_code)
      basket.add(red_widget_code)
      basket.add(red_widget_code)
      # Subtotal: 3 * 32.95 = 98.85
      # BOGO discount for 1 pair: 32.95 * 0.5 = 16.475
      # Total: 98.85 - 16.48 = 82.37
      expect(basket.total).to eq(82.37)
    end
  end

  # THIS IS THE ACTUAL TEST SUGGESTED IN THE ASSIGNMENT INSTRUCTIONS
  describe "Example Baskets from Requirements" do
    let(:basket) { Basket.new(product_catalogue, [bogo_red_offer], DeliveryRule.new) }

    it "calculates B01, G01 = $37.85" do
      basket.add(blue_widget_code)  # $7.95
      basket.add(green_widget_code)  # $24.95

      expect(basket.total).to eq(37.85)
    end

    it "calculates R01, R01 = $54.37" do
      basket.add(red_widget_code)  # $32.95
      basket.add(red_widget_code)  # $32.95

      expect(basket.total).to eq(54.37)
    end

    it "calculates R01, G01 = $60.85" do
      basket.add(red_widget_code)  # $32.95
      basket.add(green_widget_code)  # $24.95

      expect(basket.total).to eq(60.85)
    end

    it "calculates B01, B01, R01, R01, R01 = $98.27" do
      basket.add(blue_widget_code)  # $7.95
      basket.add(blue_widget_code)  # $7.95
      basket.add(red_widget_code)  # $32.95
      basket.add(red_widget_code)  # $32.95
      basket.add(red_widget_code)  # $32.95

      expect(basket.total).to eq(98.27)
    end
  end

  describe "Edge Cases" do
    let(:basket) { Basket.new(product_catalogue, [bogo_red_offer], DeliveryRule.new) }

    it "handles empty basket" do
      expect(basket.total).to eq(0.0) # no delivery charge
    end

    it "handles single inexpensive item" do
      basket.add(blue_widget_code)  # $7.95
      expect(basket.total).to eq(12.90)  # $7.95 + $4.95 delivery
    end

    it "handles prices at delivery charge boundaries" do
      # test at $50 boundary
      basket.add(green_widget_code)  # $24.95
      basket.add(green_widget_code)  # $24.95
      # subtotal: $49.90 ($24.95 + $24.95)
      # delivery charge: $4.95 (under $50)
      expect(basket.total).to eq(54.85)  # $49.90 + $4.95 delivery (under $50)

      # Test over $90 boundary with BOGO
      basket.add(red_widget_code)    # $32.95
      basket.add(red_widget_code)    # $32.95 (gets 50% off)
      # subtotal: $49.90 + $65.90 = $115.80
      # BOGO discount: $32.95 * 0.5 = $16.48
      # after BOGO: $115.80 - $16.48 = $99.32
      # free delivery (over $90)
      expect(basket.total).to eq(99.32)
    end

    it "handles mixed widgets with multiple BOGO pairs" do
      basket.add(red_widget_code)    # $32.95
      basket.add(blue_widget_code)   # $7.95
      basket.add(red_widget_code)    # $32.95
      basket.add(green_widget_code)  # $24.95
      basket.add(red_widget_code)    # $32.95
      basket.add(red_widget_code)    # $32.95

      # basket has 2 pairs of red widgets
      # subtotal: $164.70
      # BOGO discount: 2 * ($32.95 * 0.5) = $32.95
      # after discount: $131.75
      # free delivery (over $90)
      expect(basket.total).to eq(131.75)
    end

    it "handles repeated add/clear operations" do
      basket.add(red_widget_code)
      basket.add(red_widget_code)
      expect(basket.total).to eq(54.37)  # $65.90 - $16.48 BOGO + $4.95 delivery

      basket.clear
      expect(basket.total).to eq(0.0)

      basket.add(blue_widget_code)
      expect(basket.total).to eq(12.90)  # $7.95 + $4.95 delivery
    end

    it "handles invalid product codes gracefully" do
      expect { basket.add("INVALID") }.to raise_error(ArgumentError, /not found in product catalogue/)
      expect(basket.total).to eq(0.0)  # basket should still be empty and valid
    end
  end
end
