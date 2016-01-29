# Shopify Scripts - Examples

**Shopify Scripts is only available to select Shopify merchants**

Shopify's Script Editor allow you to write Ruby scripts that can modify the prices and properties of line items in your store's cart. With scripts, you can create discounts that will be applied automatically based on the items and properties of a cart. This repository provides examples of scripts that can be creating with Shopify's Script Editor.

## Usage

```ruby
# Use an array to keep track of the discount campaigns desired.
CAMPAIGNS = [
  # $5 off all items with the "sale" tag
  ItemCampaign.new(
   TagSelector.new("sale"),
   MoneyDiscount.new(5_00, "5$ off all items on sale",),
  ),

  # 10% off all items with a price lower than $100
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

Campaigns are Ruby classes that organize discounting. They are responsible for tracking the eligibility of discounts, selecting items and applying discounts.

* **`ItemCampaign`**: Discount all the products with the selected tag.
* **`BogoCampaign`**: Give *x* free items when *y* items have been purchased (for example, "buy one get one free").

### Discounts

Discounts modify the prices of line items.

### Selectors

Selectors find items that are eligible for discounting.

### Partitioners

Partitioners divide line items into non-discounted and discounted items. They are used for `BogoCampaign`. For example:

```ruby
BogoCampaign.new(
  TagSelector.new("sale"),
  PercentageDiscount.new(100, "Third item is free"),
  LowToHighPartitioner.new(2,1),
)
```

1) The `TagSelector` finds all items that have the `sale` tag.
2) The `LowToHighPartitioner` sorts all items with prices ascending (low to high), and then returns every 3rd item (skipping 2, taking 1).
3) The `PercentageDiscount` then applies 100% discounts on all items returned by the partitioner.
