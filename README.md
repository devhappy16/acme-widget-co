# Piktochart - Acme Widget - Coding Assignment

Hi there,

I found this to be a short, fun challenge. This readme contains my opinions and idealogy behind the code I wrote. I tried my best to follow the instructions as I understood them.

## Design & Implementation

### 1. Basket
- The entrypoint to the application is the Basket initialization.
- As instructed, a Basket can be initialized by passing a product_catalogoue, offers and delivery_rule.
  - argument 1: `product_catalogue` (instance of `ProductCatalogue`)
  - argument 2: `offers` (array of `Offer` instances)
  - argument 3: `delivery_rule` (instance of `DeliveryRule`)
- initialization of `Basket` without argument 1 and argument 3 will generate a fallback configuration with default catalogue and delivery rule.
- the default catalogue will have all widgets defined in the codebase (red, green, blue); more on this in the later parts of this file.
- the default delivery rule has the delivery charge calculation logic as defined in the assignment instructions.

### 2. Widget
- `Widget` is something that a user buys and adds to their basket. The `Basket` model refers to these widgets as `items` internally.
- `Widget` has a parent class widget.rb and sub classes inside the widgets module, namely `RedWidget`, `GreenWidget` and `BlueWidget`.
- I've tried to implement the strategy pattern here such that other widget classes can be added as required.
- The initialization of these widgets can be done by invoking the `.new` methods; e.g. `RedWidget.new`, `GreenWidget.new`
- The attributes for these widgets are defined as constants in the child widget classes for now and the values for these attributes are used for widget initialization.
- The current Widget implementation is simple enough where the child classes override the initialize method only to set the attributes based on their types.
- The current widget attributes are: `code`, `name`, `price` which are predefined for each widget according to the instructions.

### 3. Offer
- An offer changes the total price of the basket.
- An offer has a logic that determines how much discount needs to be given based on the total price of the basket.
- `Offer` has a base class and the child classes are implemented inside the offers module.
- Currently there are 2 offers and the implementation of these offers have been tested in the `basket_spec.rb`.
- The `red_widget_bogo_offer` was added as instructed and the `green_widget_all_free_offer` was added for further testing.
- A critical part of this entity (offer) is the precedence value which is currently defined in the constant `ACTIVE_OFFER_CODES` for convenience. When a basket is initialized with multiple offers, it determines the precedence of the offer to apply based on the index of the `offer_code` in this constant.
- An `offer_code` and `description` are attributes of an `Offer` that are defined as methods to distinguish between the types.
- Although the description field is not used at all, I can see it's potential use so decided to just have it in place.
- An ideal question about the use of these methods `offer_code` and `description` could be:
  > Why did I choose to not define them in constants like I did for widgets?

  - At the back of my head, I wanted to treat the `Widget` attributes as actual real-world attributes that ideally were supposed to be stored in a database column if this application scales up. The attributes needed to come from the child `Widget` classes and in case of widgets, the parent/base class doesn't really have much other responsibility.
  - In case of `Offers`, I wanted to have some sort of validation for the `offer_code` being used while instantiating. Enforcing child classes to defined a method `offer_code` helped with this and I had to implement the `validate_offer_code!` method in the parent class as the `ACTIVE_OFFER_CODES` constant cannot be defined elsewhere. Because we're not using a framework backed model-like validations, I couldn't think of a better way to enforce child offer classes to define an `offer_code`.
  - This probably isn't the best and convincing answer for the inconsistency question but still, it wouldn't do much harm in my opinion.

## Delivery Rule
- The `DeliveryRule` entity only calculates the delivery charge based on the discounted amount of the baseket.
- Currently the base class implements the delivery charge calculation logic as instructed in the assignment.
- There's also a `FreeDeliveryRule` which overwrites the `#calculate_delivery_charge` method to return 0 (no delivery charge at all). This method was introduced later while writing specs as I realised the need for testing the overall functionality based on different configurations for the basket.
- More delivery rules can be added as required. The implementation is simple and the child classes should only overwrite `#calculate_delivery_charge` if implemented.

## Testing
- I've added RSpec and used it to test the business logic because that's the only testing framework I'm most comfortable with.
- The core logic for testing can be found in `specs/basket_spec.rb`.
- I've tried to cover the basic and some edge/boundary test cases that I could think of.
- Obviously tests can be made more robust and made to cover a wider business logic, given the time constraint and what is expected out of this assignment, I think the current tests are good enough.

## How it works?

A large part of how this codebase works can be found in `specs/basket_spec.rb` itself. However, here are some categorized examples to help you get started with different ways to initialize and use the Basket:

### Examples

#### 1. Default Basket Initialization
```ruby
basket = Basket.new
basket.add_item(RedWidget.new)
basket.add_item(BlueWidget.new)
puts basket.total # calculates total with default catalogue, no offers, and default delivery rule
```

#### 2. Basket with Offers (e.g., BOGO on Red Widget)
```ruby
offer = Offers::RedWidgetBogoOffer.new
basket = Basket.new(nil, [offer])
basket.add_item(RedWidget.new)
basket.add_item(RedWidget.new)
puts basket.total # applies BOGO offer to red widgets
```

#### 3. Basket with Free Delivery Rule
```ruby
free_delivery = DeliveryRules::FreeDeliveryRule.new
basket = Basket.new(nil, [], free_delivery)
basket.add_item(BlueWidget.new)
puts basket.total # no delivery charge applied
```

#### 4. Fully Customized Basket (Custom Catalogue, Multiple Offers, Custom Delivery Rule)
```ruby
# custom_catalogue = custom catalogue classes to be implemented later

offers = [Offers::RedWidgetBogoOffer.new, Offers::GreenWidgetAllFreeOffer.new]
custom_delivery = DeliveryRules::FreeDeliveryRule.new # currently only have FreeDeliveryRule as the custom delivery rule
basket = Basket.new(nil, offers, custom_delivery)
basket.add_item(GreenWidget.new)
basket.add_item(RedWidget.new)
basket.add_item(BlueWidget.new)
puts basket.total # applies all custom logic
```

Feel free to configure the basket in a few different ways to test the codebase.

## Enhancements
- Given the small scale of the codebase and the non-persistent data structures for widgets, baskets, offers, etc. maybe the next step can be to add some form of persistence and indexing for these records.
- I just realised while writing this readme that the `Baseket#initialize` method should've supported keyword parameters instead of current named parameters.
  - e.g. `Basket.initialize(catalogue:, offers:, delivery_rule:)`
  - This is more practical and comprehensible for the basket initialization.
  - Because this readme will be my final commit and I've documented this potential enhancement here, I'll not make any changes to the codebase now.

### Thank you !!!
