# base/default catalogoue

require_relative "widget"
require_relative "widgets/red_widget"
require_relative "widgets/blue_widget"
require_relative "widgets/green_widget"

class ProductCatalogue
  attr_reader :all_widgets

  def initialize
    red_widget = Widgets::RedWidget.new
    blue_widget = Widgets::BlueWidget.new
    green_widget = Widgets::GreenWidget.new

    # default catalogue contains all widgets (currently red, blue, green)
    # create a custom catalogue class to initialize with different set of widgets
    @all_widgets = {
      red_widget.code => red_widget,
      blue_widget.code => blue_widget,
      green_widget.code => green_widget
    }
  end

  def find_by_code(code)
    all_widgets[code]
  end
end
