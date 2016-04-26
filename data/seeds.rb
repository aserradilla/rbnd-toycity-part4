require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  10.times do
    name = Faker::Commerce.product_name
    brand = Faker::Company.name
    price = Faker::Commerce.price
    Product.create(name: name, brand: brand, price: price)
  end
end
