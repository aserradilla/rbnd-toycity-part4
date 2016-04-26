require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.create(attributes = nil)
    product = Product.new(attributes)
    # If the product is in the database, returns the product
    CSV.foreach(@@data_path, headers: true) do |row|
      if row["id"] == product.id
        return product
      end
    end
    # If the products is not in the database, we insert the product and return the product
    CSV.open(@@data_path, "a+") do |csv|
      csv << [product.id.to_s, attributes[:brand].to_s, attributes[:name].to_s, attributes[:price].to_s]
    end
    return product
  end

  def self.all
    product_arr = []
    CSV.foreach(@@data_path, headers: true) do |row|
      product_arr.push Product.new(id: row["id"], name: row["product"], brand: row["brand"], price: row["price"])
    end
    return product_arr
  end

  def self.first(number = 1)
    product_arr = self.all
    return number == 1 ? product_arr[0] : product_arr.first(number)
  end
end
