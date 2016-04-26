require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.create(attributes = nil)
    # If the product is in the database, returns the product
    CSV.foreach(@@data_path, headers: true) do |row|
      if row[1] == attributes[:brand] && row[2] == attributes[:name] && row[3] == attributes[:price]
        return Product.new(attributes)
      end
    end
    # If the products is not in the database, we insert the product and return the product
    product  = Product.new(attributes)
    CSV.open(@@data_path, "a+") do |csv|
      csv << [product.id.to_s, attributes[:brand].to_s, attributes[:name].to_s, attributes[:price].to_s]
    end
    return product
  end

  def self.all
    product_arr = []
    CSV.foreach(@@data_path, headers: true) do |row|
      product = row.inspect
      product_arr.push Product.new(id: product[0], brand: product[1], name: product[2], price: product[3])
    end
    return product_arr
  end

  def self.first(number = 1)
    product_arr = self.all
    return number == 1 ? product_arr[0] : product_arr.first(number)
  end
end
