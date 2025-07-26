require "rspec"
require_relative "../basket"
require_relative "../product_catalogue"
require_relative "../offers/red_widget_bogo_offer"
require_relative "../delivery_rules/free_delivery_rule"

RSpec.describe "Acme Widget Co Basket Test" do
  let(:product_catalogue) { ProductCatalogue.new }
  let(:free_delivery) { DeliveryRules::FreeDeliveryRule.new }
  let(:bogo_red_offer) { Offers::RedWidgetBogoOffer.new }

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

  # to test if the actual discount logic including pairs is working correctly
  describe "Red Widget Only Basket With Buy One Get Other Half Price Offer" do
    let(:basket) { Basket.new(product_catalogue, [bogo_red_offer], free_delivery) }

    it "applies no discount for single red widget" do
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])
      expect(basket.total).to eq(32.95)
    end

    it "applies BOGO offer for a pair of red widgets" do
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])
      # Subtotal: 2 * 32.95 = 65.90
      # After BOGO discount: 65.90 - (32.95 * 0.5) = 49.42
      expect(basket.total).to eq(49.42)
    end

    it "applies BOGO offer for multiple pairs correctly" do
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])

      # Subtotal: 4 * 32.95 = 131.80
      # BOGO discount for 2 pairs: 2 * (32.95 * 0.5) = 32.95
      # Total: 131.80 - 32.95 = 98.85
      expect(basket.total).to eq(98.85)
    end

    it "handles odd numbers correctly applying BOGO only to pairs" do
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])
      basket.add(Widgets::RedWidget::RED_WIDGET[:code])
      # Subtotal: 3 * 32.95 = 98.85
      # BOGO discount for 1 pair: 32.95 * 0.5 = 16.475
      # Total: 98.85 - 16.48 = 82.37
      expect(basket.total).to eq(82.37)
    end
  end
end
