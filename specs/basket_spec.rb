require "rspec"
require_relative "../basket"
require_relative "../product_catalogue"
require_relative "../delivery_rules/free_delivery_rule"

RSpec.describe "Acme Widget Co Basket Test" do
  let(:product_catalogue) { ProductCatalogue.new }
  let(:free_delivery) { DeliveryRules::FreeDeliveryRule.new }

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
end
