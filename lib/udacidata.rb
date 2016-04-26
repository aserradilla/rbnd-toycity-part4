require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"
  create_finder_methods("name","brand","price")
  # Creates a product and adds it to the database if is not already in it
  def self.create(attributes = nil)
    product = Product.new(attributes)
    # If the product is in the database, returns the product
    CSV.foreach(@@data_path, headers: true) do |row|
      if row["id"].to_i == product.id
        return product
      end
    end
    # If the products is not in the database, we insert the product and return the product
    CSV.open(@@data_path, "a+") do |csv|
      csv << [product.id.to_s, attributes[:brand].to_s, attributes[:name].to_s, attributes[:price].to_s]
    end
    return product
  end

  # Returns all the products in the database
  def self.all
    product_arr = []
    CSV.foreach(@@data_path, headers: true) do |row|
      product_arr.push Product.new(id: row["id"], name: row["product"], brand: row["brand"], price: row["price"])
    end
    return product_arr
  end

  # Returns the first n products of the database
  def self.first(number = 1)
    product_arr = self.all
    return number == 1 ? product_arr.first : product_arr.first(number)
  end

  # Returns the last n products of the database
  def self.last(number = 1)
    product_arr = self.all
    return number == 1 ? product_arr.last : product_arr.last(number)
  end

  # Finds a product by its id
  def self.find(index)
    product_arr = self.all
    CSV.foreach(@@data_path, headers: true) do |row|
      if row["id"].to_i == index
        return Product.new(id: row["id"], name: row["product"], brand: row["brand"], price: row["price"])
      end
    end
  end

  # Removes a product from the database
  def self.destroy
  end
end
