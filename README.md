# Shopify Scripts - Examples

Shopify's Script Editor allow you to write scripts in Ruby that can modify the prices and properties of line items in your store's cart. Using scripts, you can create discounts that will be applied automatically based on the items and properties of a cart. This repository provides examples of scrits that can be used.

## Usage

```ruby
# Use an array to keep track of the discount campaigns desired.
CAMPAIGNS = [
  # Give the product "A" a 10% discount with the
  # discount message: "10% off A"
  # ItemCampaign.new(
  #   TagSelector.new("sale"),
  #   MoneyDiscount.new(5_00, "5$ off all items on sale",),
  # ),

  # Give the product "Bar Chart" a $5 discount with the
  # discount message: "$5 off Bar Chart"
  # ItemCampaign.new(
  #   PriceSelector.new(:lower_than, Money.new(cents: 100_00)),
  #   PercentageDiscount.new(10, "10% off all items under 100$"),
  # ),

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

### Discounts

Discounts are Ruby classes that manipulate the prices of line items. They respond to `apply`.

### Selectors

Selectors are Ruby classes that find line items eligible for discounting.
