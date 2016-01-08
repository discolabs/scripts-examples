# Shopify Scripts - Examples

**Shopify Scripts is a feature only available to select Shopify merchants**

Shopify's Script Editor allow you to write scripts in Ruby that can modify the prices and properties of line items in your store's cart. Using scripts, you can create discounts that will be applied automatically based on the items and properties of a cart. This repository provides examples of scripts that can be used.

## Usage

```ruby
# Use an array to keep track of the discount campaigns desired.
CAMPAIGNS = [
  # 5$ off all the items with the "sale" tag
  ItemCampaign.new(
   TagSelector.new("sale"),
   MoneyDiscount.new(5_00, "5$ off all items on sale",),
  ),

  # 10% off all items with a price lower than 100$
  ItemCampaign.new(
    PriceSelector.new(:lower_than, Money.new(cents: 100_00)),
    PercentageDiscount.new(10, "10% off all items under 100$"),
  ),

  # Give every 3rd item with the tag "letter" for free
  BogoCampaign.new(
    TagSelector.new("letter"),
    PercentageDiscount.new(100, "Third item is free"),
    LowToHighPartitioner.new(2,1),
  )
]

# Iterate through each of the discount campaigns.
CAMPAIGNS.each do |campaign|
  # Apply the campaign onto the cart.
  campaign.run(Input.cart)
end

# In order to have the changes to the line items be reflected, the output of
# the script needs to be specified.
Output.cart = Input.cart
```

## Exploring

This repository aims to build small, reusable components that can be assembled to write fully-functional discount scripts.

### Campaigns

Campaigns are Ruby classes that orchestrate discounting. They are responsible for tracking the eligibility of a discount, selecting items and applying discounts.

* **`ItemCampaign`**: Discount all the products with the "on sale" tag.
* **`BogoCampaign`** eg: Purchase 2 items with the "on sale" tag, get the 3rd one for free.

### Discounts

Discounts are responsible for modifying the prices of line items. 

### Selectors

Selectors are responsible for finding items that are eligible for discounting. 

### Partitioners

The partitioners are responsible for dividing line items into non-discounted and discounted items. They are used for `BogoCampaign`. Taking for example the following campaign:

```ruby
BogoCampaign.new(
  TagSelector.new("sale"),
  PercentageDiscount.new(100, "Third item is free"),
  LowToHighPartitioner.new(2,1),
)
```

1) The `TagSelector` will find all items that hate the `sale` tag.
2) The `LowToHighPartitioner` will sort all items with prices ascending (low to high), and will then return every 3rd item (skipping 2, taking 1).
3) The `PercentageDiscount` will then apply 100% discount on all items returned by the partitioner.
